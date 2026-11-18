Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031122;
	b=gWX/y4AJnBBg/N9ojVwmfsmeBs2x4GFjPpQfreOd+ntmUCMgY7cudi9alMRWGz3VUxlI
	 TSguckSp2BOK/hOV3Ju8Qvu70RnqjF8k0UxlB6chJThPtD7x4der2XUJVi+oKSlinfxtl
	 3Ts9Kg6toeKT7f3OJUxUF0YnbZ2tMWDfxw3t5fPTxk7bqs8Sh+3RQCSU66iKrpLgN3B6P
	 v256LdA6Qza5KBBF5bArrmxYJh+DOcolm/s3AWm1ORea7hM2XTzih8cmND/fWWMtup2fz
	 vbiuuZ+zuU2sOcIQ/uiYmQ0GlGGjGXdAFhqzPMLUET/zeLB8vawcrv8TMrgl1fumPFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfB3RrZhnes4PDc64vkVvFvLJT2dhTFgGZ725oNoduE=;
	b=XNv/pBi0vUqjCvbMXi5s9p6SQlgAwd7xPLlgBZgnTsNsUSRocgIUUTqBWFwaMDiZpsYX
	 GXpSJDX4ZHJ/BrosKHD+EtmEhFgD04JegCEFixtV6cWY1UdR67AU6Jt4xGvgSJoFFPfNX
	 vBnBD98r0jdhMw+7/DLnRh2NPjhHWEUDshgCF+rH+NDsAnc2Xko3wyIn/cBi99gGmkGuW
	 W5UyLP/e+HMWlKc0pwNBZwrLisBvDu+4ulvAxoxmkDEBsELGTRyKV1O+zsRQhkQz5kVrr
	 4m4fPeRCN0GV4IjIVgNIBoqv/Cf4mKgZcztLZFU1EKNDlMLiBUYL7Zo843tfknM7R5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vap2gXcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F5606A32F;
	Wed, 18 Nov 2026 19:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vap2gXcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAFF1F000C7;
	Wed, 18 Nov 2026 19:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031121;
	bh=IfB3RrZhnes4PDc64vkVvFvLJT2dhTFgGZ725oNoduE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vap2gXcgeE+P0Pyt/UBB2jw/S6CyFqvkNsRTdh/eCBHEqDU5bvt+T59vPJuL9TW4X
	 UbPzbjLEiJ22VCl7U4VTUsRrcVUQNji1DGg63kVbMA+p32QzFEOyGsDCjyqMg1ho+Q
	 8AdBeCjF2bF718fHEkAZYfO+Wjdr5oVDkF52K7Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leizhen Zhang <lzsx618@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0946/1756] gen_init_cpio: stop parsing on lines with a missing argument list
Date: Wed, 18 Nov 2026 15:51:13 +0100
Message-ID: <20261118150047.740399982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index edcdb8abfa31c..38df4800f6066 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -672,6 +672,7 @@ int main (int argc, char *argv[])
 				"ERROR: incorrect format, newline required line %d: '%s'\n",
 				line_nr, line);
 			ec = -1;
+			break;
 		}
 
 		for (type_idx = 0; file_handler_table[type_idx].type; type_idx++) {
-- 
2.53.0



