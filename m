Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D147DA78;
	Thu, 15 Aug 2024 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728727; cv=none; b=fSwQygIBXn+VZoslcxK4BqsOoruB4B78NskB6aoAmD8exufdNw0rf5t8prv9RkSM/CNxzgxtPQEuxTK235Xd7PLAkGmR7hqo5imZ6FyW4f/rpurJMs2LYSOKoy52rBHFwlepNIJTGfK8B0MTgu2Rp80ydvF02Ba2r23N6G/mUDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728727; c=relaxed/simple;
	bh=1hU2SZaXXOiGMmybE3raRzRgOQ+XoUNimH9k+pPbU1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpoclGVA3TBN1WwwGtQYNAj3TgDue4n8f/K3FPAYvqH/4n516Qf8aTLtD6brHpawa3luabzO56ejPBDYa/xcCpZPr5tGCGsFf4GEjy6Ws1RXXcvFAGWA3GImQ51Nws2qyMw1zCvuppGg90Sy+dtYGPbTQLYEItcWGvZPauk7Qdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGcjGib4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGcjGib4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA8BC32786;
	Thu, 15 Aug 2024 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728727;
	bh=1hU2SZaXXOiGMmybE3raRzRgOQ+XoUNimH9k+pPbU1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGcjGib4/sVIGJGo7WrvmnzUyG4YIDIJ3cc8CggEMKQw+ollQK9TmQ8Lmh42belpU
	 rZ+zaajKsTNIuxnFbRXjnfnH/GmZfvSrcq+BFAFU10PnFw98KZRqvNNAw3wZXuK5s1
	 dwrrGmzfRWXLDIWqhA7RJXLNJ8o1qg3bMr4n63ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.19 091/196] platform: mips: cpu_hwmon: Disable driver on unsupported hardware
Date: Thu, 15 Aug 2024 15:23:28 +0200
Message-ID: <20240815131855.562711342@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit f4d430db17b4ef4e9c3c352a04b2fe3c93011978 upstream.

cpu_hwmon is unsupported on CPUs without loongson_chiptemp
register and csr.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/mips/cpu_hwmon.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/mips/cpu_hwmon.c
+++ b/drivers/platform/mips/cpu_hwmon.c
@@ -164,6 +164,9 @@ static int __init loongson_hwmon_init(vo
 		goto fail_hwmon_device_register;
 	}
 
+	if (!csr_temp_enable && !loongson_chiptemp[0])
+		return -ENODEV;
+
 	nr_packages = loongson_sysconf.nr_cpus /
 		loongson_sysconf.cores_per_package;
 


