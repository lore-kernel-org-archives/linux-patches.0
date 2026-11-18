Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056488;
	b=sntq8mj49y6TFYjSlHvoK4j1MfzXt7l2vMm9DsgL1BP1USFQaLDnPozbteqA9PqVBz96
	 15q7DSQ4VUdqugZv7kOTgmPheJGyqYCiQ/SF4GBGdwd+SPVG9/xJckLG9MuNtJa8yFf2s
	 0EEEuTQhi+h9yl9Z0rz1YZCRUSs9uIF86qb51x/Dp/DXczv56Ki4K3JQYABaeMYI0eupq
	 aIoDmAD9MF34Qvs6Vs4m78hkT4Yj7JaerfrzDbex2f6m//SgFuT8ikmqS81oTVJ8vJ0jL
	 XfjS3T0TSnUl2Q3Wj93+zEbmi4aUdZTGdbCdY8J1+23v+UYJ3XVAYFFI0EqnyoUjJyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KWsTxmiTdp7xaGNEPr2HoH1CFRc4dqZIlHMR9jOWkIQ=;
	b=GABGuXxQjZR1pNCs8XfhnIGXWXi5BlUnnRcC6bNybgzqjI0T9+ZWThzK3mELXXwjKoyo
	 hQR8GYfO6TBSLuschynkYIMvtm8TCsqX4080gTke0AzqH74CR4dMScieG29USn9BpG3nn
	 WRcCmwB3zilyg8W5qkYn6CKV+9ssav9/IEkPkSJtuJwtAbwBLg7YHLcu5WkUBUFHrqp+f
	 tXWOw90SgDzPoRoGtkXMdL9BJbIAb9iN07T6ZHZHJMoj3wwEAixv2JPt7SD2KV8UD3yjQ
	 64SyS0/u3RYxPk4nwA7QUD1FWtav+lHCgc7BdIG0Kb0DpZQlK/NXXJOnrq0b9k8pIAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vhYG84Ng;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F2E606A320;
	Thu, 19 Nov 2026 02:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vhYG84Ng
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7B51F000C6;
	Thu, 19 Nov 2026 02:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056487;
	bh=KWsTxmiTdp7xaGNEPr2HoH1CFRc4dqZIlHMR9jOWkIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhYG84NgZC8Cl2O85FQ/vmucDtqJqEKOSZ+tus8JCQNleNcvwtd4JwDsjI52R7pQ4
	 cjPbq2iWl/CBxiCIua8QfJR4Fn1EdfLYcmxdvFvdMFeINU2YNU/7/d36maPjbl+4Pa
	 soFiBrzCnqVSvv4Iwm2RcM9rB1OlCky+Q9NRqbm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2007/2214] bpftool: Fix inverted tracefs validation when scanning /proc/mounts
Date: Wed, 18 Nov 2026 16:01:23 +0100
Message-ID: <20261118150131.047961081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 21c755efaab1f40c2588ae5acbfa319a6d7d3638 ]

The /proc/mounts fallback in get_tracefs_pipe() accepts only non-tracefs
mount points, so a tracefs mounted outside the default locations is
ignored: bpftool prog tracelog then mounts a second tracefs, or exits
silently with --nomount. Negate the condition.

Fixes: be3245e22d22 ("tools: bpftool: attempt to mount tracefs if required for tracelog cmd")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261016015057.127061-1-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/tracelog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/tracelog.c b/tools/bpf/bpftool/tracelog.c
index e80a5c79b38f0..e060d04485fd1 100644
--- a/tools/bpf/bpftool/tracelog.c
+++ b/tools/bpf/bpftool/tracelog.c
@@ -88,7 +88,7 @@ static bool get_tracefs_pipe(char *mnt)
 	fclose(fp);
 
 	/* The string from fscanf() might be truncated, check mnt is valid */
-	if (found && validate_tracefs_mnt(mnt, TRACEFS_MAGIC))
+	if (found && !validate_tracefs_mnt(mnt, TRACEFS_MAGIC))
 		goto exit_found;
 
 	if (block_mount)
-- 
2.53.0



