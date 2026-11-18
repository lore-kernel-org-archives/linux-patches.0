Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040986;
	b=N/z1mJi65wPFmht93fsQZCtcxjSUdYq0jVfvq+/MwMtxwJXe0pBOsc3KsXL/GrInApa0
	 4wazmc20QQvwZfkK3F3gSyprX+ckplLkP+9TMtwwNcQMa1P3s+QXjvAqFV4ekndU7NPm2
	 oxv/tNczz7UBz6G9QIwzA23gbPm1FvPiblDwzAcvpMqa5TGGJ7mTL6PaH7/lYbfmOL24n
	 P86uG9o/izSZ37DfCMbFIJyekv7WiGGrgvze42Qogfc78bccCyNCwlY3d0g/XOUBWExXO
	 2F3erJDSgoz4K/pdJcMtuAW8fGMAPn1RCagJAR6RdTswfS/Y+OJNZrUm1rPl58etLCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rhQU8LEWVG89lIKhiXEFPKO8aZwPu3NRqfaj9P++tFE=;
	b=HoXqscSOwdE16NyX8uGgj+2t5RWJEDpMsBWV22u5H3DhjhmdHSihePwrBl6ibB/Ft440
	 ILpiBDhV/lnqAaWX9kjHs75dCP0mrPinJY2yFs7yTjC4WzUvxMIo97kGtBkWlFqpJ/vC/
	 G8KUv/DGNNdV/RlUkeNOwq8DMi/v2bRUARLMk5Rtn1coTQOW0DfrVyE9MJqPlUEo7kA+x
	 EeSRLdKb5Oo9FB4NUjL3cqHKu8pE2YpJz+t63LPr1yKn0fqunJm9RXR+A2HRnPg7Pu/pZ
	 CtwB3vML8NfVhz1k+vFF7K92oeQOoIUFltaZQydBlTfLWWp28urz9ohrPl3dzYzoz2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZJf4O088;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF03606A320;
	Wed, 18 Nov 2026 22:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZJf4O088
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245901F000C4;
	Wed, 18 Nov 2026 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040986;
	bh=rhQU8LEWVG89lIKhiXEFPKO8aZwPu3NRqfaj9P++tFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJf4O088Z4E9B2fCw/U1Lo6+4LSOjw40f5IewkUBS0UVLwCBjstG4jQyrZW5qiRCa
	 KrUAzS2op3B0Qgvhm7kZW2G1+HEnMgMjuXkFBIyK3nC+Y1dfnpx9+c8haqpzMpJPOR
	 ESJBCMjwQAU61ULAgvn5d24iO6vBcZYv3aBlFuIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leizhen Zhang <lzsx618@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2652/3318] gen_init_cpio: stop parsing on lines with a missing argument list
Date: Wed, 18 Nov 2026 15:54:34 +0100
Message-ID: <20261118150440.605670707@linuxfoundation.org>
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
index 61230532fef10..14b271e7ee68f 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -663,6 +663,7 @@ int main (int argc, char *argv[])
 				"ERROR: incorrect format, newline required line %d: '%s'\n",
 				line_nr, line);
 			ec = -1;
+			break;
 		}
 
 		for (type_idx = 0; file_handler_table[type_idx].type; type_idx++) {
-- 
2.53.0



