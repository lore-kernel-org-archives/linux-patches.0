Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037973;
	b=m69868Y8sPHbfwh4DutS0HRzd4JwMJ+AOXnKLh1cPQ7mC6Kjo6s77TinAMSbPBo3qPSO
	 FnrjFxYRdTOpH0HjeSct+lCvlsVaPxK8AtkRWjiOvY7vg3O5QlSZrY6S7f2n5fdnnvJlm
	 ljLT4/6i5YvnzXgX7c/PbsNBi/BCUjZK7nNHI7suNjE9CszjM7jpDE636qPTahlNHk5pv
	 YuYV7dtEkLHsJenbkSdXRLWvYYGkfLBVywgk1F6EBMPgeRaNMsHA/mzml5aemhaJdYIhF
	 sKJ2k2BEkVEf+c31CquFEx/U13h3PY3zFx6hXtJRh4vpfZ0fi2aIee+7a5ApztIwC7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x8dLVu8ch+javY8OZmgarR/8YYrelLnVHnB6lEYemAw=;
	b=3eUsFCsvT4hE2VuWmAsNy7trgvLYSOAWbua8g4FWbY+xH8ICuXHfyYHBUpG+HlHvJTX9
	 81+qAmoQ56koyzxCsI6706NKaOFFhirIQ1LXlSGoKkEgFOF7K2V6sCOrr8AGsgfM2HFOs
	 YXm9ezqfWpRoB+z0fMGHa5B/V90dHNsSzg+ozWJ7zKmHwfGAVtj0eTXcz0jPXT7crND3h
	 WPUcLSrl+REC+SnJsVlcS6eNP8x5hXw7GVWjO7Okx03wCQSj6O9XNQ9ZKq79bJbTYJatV
	 jDKpL2E1iMkBIQK8GSppYc22iePkfoKlSiywvE6Q6oIxi4g6NGtnUsnHVL6wBZHIPCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDHwiwHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457CE606A31C;
	Wed, 18 Nov 2026 21:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDHwiwHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538DD1F000C4;
	Wed, 18 Nov 2026 21:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037972;
	bh=x8dLVu8ch+javY8OZmgarR/8YYrelLnVHnB6lEYemAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDHwiwHIKQ0jickEaS2WW0M95ulqWd2OPp/ySARuIhSAwOqpI8BtU5+fHOEvLNfLK
	 vm+BSjEVHdcJrJaP/2iIr/WxbIS4b10pdxPO/KYcDdJ1B6vtwBlBQvFVOudWIR0Pz6
	 O+7PiJahDjf4wpDXQsJpGRwnMrqnpfKKVa1f923A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joanne Chang <joannechien@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1582/3318] f2fs: allow pinning empty compressed files
Date: Wed, 18 Nov 2026 15:36:44 +0100
Message-ID: <20261118150408.585991355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Chang <joannechien@google.com>

commit 2eebc31ae5f53e1066bb6238c8087c23b688ad17 upstream.

Commit a64a3fec11e7 ("f2fs: force out-place update for all writes on
compressed file") updated f2fs_should_update_outplace() to always
return true for compressed files. However, this function is also
called during f2fs_ioc_set_pin_file() validation, so pinning an
empty file with compression enabled now fails with -EINVAL before the
compression flag can be stripped.

Fix this by guarding the f2fs_compressed_file(inode) check with fio in
f2fs_should_update_outplace(). This preserves forced OPU for actual
compressed writes (fio != NULL), while allowing f2fs_ioc_set_pin_file()
(fio == NULL) to proceed to f2fs_disable_compressed_file(inode).

Cc: stable@kernel.org
Fixes: a64a3fec11e7 ("f2fs: force out-place update for all writes on compressed file")
Assisted-by: LLM
Signed-off-by: Joanne Chang <joannechien@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
(cherry picked from commit 2eebc31ae5f53e1066bb6238c8087c23b688ad17)
Signed-off-by: Jiucheng Xu <jiucheng.xu@amlogic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 65f933d24fe8f..435eaf4f7547b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2634,7 +2634,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 	 * If IO comes from compressed write path and fallback to raw write,
 	 * force out-place to prevent metadata-data inconsistency.
 	 */
-	if (f2fs_compressed_file(inode))
+	if (fio && f2fs_compressed_file(inode))
 		return true;
 
 	/* swap file is migrating in aligned write mode */
-- 
2.53.0



