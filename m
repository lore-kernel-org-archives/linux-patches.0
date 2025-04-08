Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FEA268C6F;
	Tue,  8 Apr 2025 11:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111572; cv=none; b=SWyB9R5SXIK4EF1QG9n0X6Q1w9GGQOjiGwpdGt2pwJSpBDj3duWand4Myhj2Eff+lmQvUwzhCbe2f4ZysrxMXFkHqQxNZO60naLM8fYc3VL8Wmh4pnoHVFb8tEd/ua3aS4HvD9bV9DpYa/xhd1XRYVa+HfbaiDDZlhopd28aPeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111572; c=relaxed/simple;
	bh=0tWB6K+om+0XTbOU8/OD2Ief9vxNl44oqExKkehPci4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5hz/3rbPVCG8HPQKiWZr0KwXQbSd6ruJ4cjufaVgjwTEfimLe9u4iDstd5QFWwKP2rPxgI7fubPcFZ+XJz0ihhrFDq77Cpg1sO+tvTFVSPJRXD1sQv3akb4E//Sq0qwU/TedmC9pk3GGHZZ3OoX9Fmr1URD58tVNPTX8nh2F00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNgpaWOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNgpaWOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3D9C4CEE5;
	Tue,  8 Apr 2025 11:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111569;
	bh=0tWB6K+om+0XTbOU8/OD2Ief9vxNl44oqExKkehPci4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNgpaWOa0VTah81+ZaUePA8BLeCmkUVvGdhDo4RPcH+m2fZGuci5OhhGMdtmH5RNu
	 HZ9mQ4FPKQgMgPFGvYF3HnVLBB8+p5Raq7XHexbaOk35HX6M5yHZ6Qof1NAC45OZR+
	 K6ZHswi2lzhWMfA1xE1UlOhO+SrbRbw1qyfrP4Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 479/731] perf machine: Fixup kernel maps ends after adding extra maps
Date: Tue,  8 Apr 2025 12:46:16 +0200
Message-ID: <20250408104925.418959152@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit f7a46e028c394cd422326caa7a2ad6ba0cd87915 ]

I just noticed it would add extra kernel maps after modules.  I think it
should fixup end address of the kernel maps after adding all maps first.

Fixes: 876e80cf83d10585 ("perf tools: Fixup end address of modules")
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/lkml/Z7TvZGjVix2asYWI@x1
Link: https://lore.kernel.org/lkml/Z712hzvv22Ni63f1@google.com
Link: https://lore.kernel.org/r/20250228211734.33781-4-acme@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 2d51badfbf2e2..9c7bf17bcbe86 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1468,8 +1468,6 @@ static int machine__create_modules(struct machine *machine)
 	if (modules__parse(modules, machine, machine__create_module))
 		return -1;
 
-	maps__fixup_end(machine__kernel_maps(machine));
-
 	if (!machine__set_modules_path(machine))
 		return 0;
 
@@ -1563,6 +1561,8 @@ int machine__create_kernel_maps(struct machine *machine)
 		}
 	}
 
+	maps__fixup_end(machine__kernel_maps(machine));
+
 out_put:
 	dso__put(kernel);
 	return ret;
-- 
2.39.5



