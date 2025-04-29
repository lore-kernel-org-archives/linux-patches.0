Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3724E00D;
	Tue, 29 Apr 2025 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946212; cv=none; b=T9xUZ0x1ux5w0JmO2hZieQPcRcptA5rwf2MMCMJ5NwNtAxRBlQ2rCRiZU8cy9MCec5wTYZth/njUwXkMH9oUYLNFmN+6HvQ40Cm2yQ5zqk/VOANhKkxoIzLFBJXPDBkUyfoLE8EOiIOt5i0RIcGKr0J9paOzbSVLAZIO2GBzJOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946212; c=relaxed/simple;
	bh=L16s0pgyKbfE78CSaQr7VAdFVgk7Z6nVtQgJ1ULIXZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdNdfcyMDEwSDqSe72GI6tC6ZPv3Dm70b4ofLPpJNX0tSXzPjLoVi3rQnupsgP2aXK1U2MD/9loooR7SdFmGpvSIEF2sIDVhdg9LXh9iA3gLlCOEiqKgdnE3+44OvJ3aIBBKpvb/3vD5XNu13pJ3doZLdPBqq0+fcRjae200mfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuhQEXlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuhQEXlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E28C4CEE3;
	Tue, 29 Apr 2025 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946212;
	bh=L16s0pgyKbfE78CSaQr7VAdFVgk7Z6nVtQgJ1ULIXZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuhQEXlToQBRG6+t+zIqssOaLFbLLcxNiDrEIei+67QT0GRNCHHhK6wsjrtsh1nG0
	 NN2doO4KqecCkrZNY+pNuFTYu++TF1FLczmnH8xBJiXJXTi+uEzfATp/yj7JUw0Rof
	 y9if+NYUnB48EAr8NxU08hRWEX+kWvRPSXnjGYQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sewon Nam <swnam0729@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 193/311] bpf: bpftool: Setting error code in do_loader()
Date: Tue, 29 Apr 2025 18:40:30 +0200
Message-ID: <20250429161128.918584898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Sewon Nam <swnam0729@gmail.com>

[ Upstream commit 02a4694107b4c830d4bd6d194e98b3ac0bc86f29 ]

We are missing setting error code in do_loader() when
bpf_object__open_file() fails. This means the command's exit status code
will be successful, even though the operation failed. So make sure to
return the correct error code. To maintain consistency with other
locations where bpf_object__open_file() is called, return -1.

  [0] Closes: https://github.com/libbpf/bpftool/issues/156

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sewon Nam <swnam0729@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Quentin Monnet <qmo@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/d3b5b4b4-19bb-4619-b4dd-86c958c4a367@stanley.mountain/t/#u
Link: https://lore.kernel.org/bpf/20250311031238.14865-1-swnam0729@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index e71be67f1d865..52ffb74ae4e89 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1928,6 +1928,7 @@ static int do_loader(int argc, char **argv)
 
 	obj = bpf_object__open_file(file, &open_opts);
 	if (!obj) {
+		err = -1;
 		p_err("failed to open object file");
 		goto err_close_obj;
 	}
-- 
2.39.5



