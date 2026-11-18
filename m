Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055888;
	b=0ro1eqXW+n7YsKm/uzLRKLmnvlj8miHEbttYRdE2JYemGleheSMLAdInt7ppoVmXVVhN
	 ktbqJQP6VGp+czeiNceBLm94tvhSlg7XTsFw0cycy7fyfpgDABeuV/GKvmC2eTdLJaKka
	 D2UZLYAOeY7ObgkQho+3dEGNwTakGS6eiULVLAarS7wrTMRW5S4vN2gh2meKuYLq8x9nA
	 zUqqvCLT7Hj8ZnsUPsqlPjX7mBIDnKJxhJnB0cv1iSnZq9cOPxJOovLChJL0ID0GkLUfE
	 L4WQ5wmJK1LsQf/ISUvyFrBBGUpZJJJ5ZF6w7jJLayyGXlmpRUWXan5bcND4Kx05bfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3eFiwg+pKPaBSIAjXV5HlRWfK4wAvr69r7XLGowwuoA=;
	b=Yhl+n1S+lK0KgzQqXq3OLvXTQGsWZlGOYEmVYEelCj+XexNNXJ8iao1pLYwHALK05+ub
	 obCO2//1jwyFv06YeJFwQ+mqSHFChh+Oz9h2jqN0u9mhKZvZnb0oUWLbhV8a+9XRoCvSf
	 s9iWYQWiyq9kFGsd+bE4IUy8G1TFMBi+69Tbmp57XwU6F5vnPdcUs/apPKtXiEO7qNu3P
	 F4WfjSWLCCOD3qAIyX17dwmqgcJif7xYxNGoq27hwxSTplqNasHtXSHpSr/BXFCxuk4gf
	 HtirLDBaXGnXf0qiRN1dyrafPzU+2vy3hRiiCxvC04e7ZPBaNsiZdW7WAHLFc86L/GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jygw5/Cm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D7C606A330;
	Thu, 19 Nov 2026 02:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jygw5/Cm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8D11F000C4;
	Thu, 19 Nov 2026 02:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055887;
	bh=3eFiwg+pKPaBSIAjXV5HlRWfK4wAvr69r7XLGowwuoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jygw5/Cm07dj04vkWr6I4dJf/+n3ouR2JD1zMYAYbwVxYIYW6OVW/KZa52iEy6laM
	 qt/Bi9bwLpOzQjvny6J9MYeOXWAaNAj+QEa3huHzTbZRNfcYucL/IZHiNo3ax88jHs
	 m7qNFo/jUPpUnRu/PMBIetQ/I2WU5b0Ze2rwNc0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leizhen Zhang <lzsx618@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1792/2214] gen_init_cpio: stop parsing on lines with a missing argument list
Date: Wed, 18 Nov 2026 15:57:48 +0100
Message-ID: <20261118150123.189575859@linuxfoundation.org>
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

From: Leizhen Zhang <lzsx618@gmail.com>

[ Upstream commit c8dd1aa0274d8ad3df82ec1b064065f410ce99ed ]

When a line in the cpio list consists of a file type followed only by
whitespace and no newline (e.g. "slink " as the last line of the file),
strtok(NULL, "\n") returns NULL. main() prints an error and sets ec, but
then carries on and passes the NULL args pointer to the type handler,
which hands it to sscanf() and crashes:

  AddressSanitizer: SEGV on unknown address 0x000000000000
    #4 __isoc99_sscanf
    #5 cpio_mkslink_line usr/gen_init_cpio.c:169

Break out of the loop as is already done for the other format error, so
that the error is reported and gen_init_cpio exits with a failure status.

Found by fuzzing gen_init_cpio built with ASan/UBSan.

Reproducer:
  printf 'slink ' > list && usr/gen_init_cpio list

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Claude:claude-opus-5-5 ASan UBSan
Signed-off-by: Leizhen Zhang <lzsx618@gmail.com>
Link: https://patch.msgid.link/20261005085729.872402-1-lzsx618@gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 usr/gen_init_cpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 03b21189d58be..06a465cb7aec9 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -599,6 +599,7 @@ int main (int argc, char *argv[])
 				"ERROR: incorrect format, newline required line %d: '%s'\n",
 				line_nr, line);
 			ec = -1;
+			break;
 		}
 
 		for (type_idx = 0; file_handler_table[type_idx].type; type_idx++) {
-- 
2.53.0



