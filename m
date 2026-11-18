Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025743;
	b=WO1U/bl9yov4N/pnZZOYrDbF5E3UhEj1KlFkgkBtdTB1CEucp4/2VYtabmrfmFXVFW4g
	 aIcaa6zVttg8VBVLl/sZNkXIFBngHNWTdoOGod/nd40H5luqN5NIe1CSYNZ1MtpVO50H3
	 hozM0ZopeHDd5jZBRqsA6qzIjn9MUXfUWTxjxE9JiQ90oDZAdjCsVXK7cUggx6Mx1PbcD
	 WbQzDaLPPFLt0k6suTdJytpJ1F7WL33S1TohW5988wc8k6ddll/6ojJvSSz772TJ5q90s
	 EQyLHjA8GTIhSMzMiDw2dn+HDZwzJh+5Eo0EDSPaevBtG/wGU5nBvUFdOtrG0sK4IVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sIUmXKOwwQ/feGNx6C8raEdUZqm4Dtuqtrf5GG1y0wM=;
	b=PwFTuqMSU1TT2UeXou8EEreqjQFqzc9a93xVsgg8lj6Y50binWqS2yok9iuJ1eTXtyA2
	 lRso5mpV6GS60L8B+8wc9gjH4f5iQEP6TSJjPxIbOMPo4jCfjCPkkaYs8RjFxwzysK3Pt
	 kyzhHyMfevAwzf8DyXHU1VryfB3K0tZXchoxVS+i3XtevHn162vkMDaSQjIFkxLMKIRii
	 eR3saZqyGP9a9liSp8mEO6HlJDnyW9Z5TH6Ph8YQBJ9rvMuJpGNtbSj93uaybg1dK5fdk
	 2uAvdHWxERK6i7azyd5K1toYdWVoutSTW943KkLSA6XCf85C69nvB/IK9ZP07mgI4Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3VnbSfT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EDE606A31C;
	Wed, 18 Nov 2026 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3VnbSfT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588801F000C7;
	Wed, 18 Nov 2026 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025742;
	bh=sIUmXKOwwQ/feGNx6C8raEdUZqm4Dtuqtrf5GG1y0wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3VnbSfT9xVV8GPmTV0ryPhRIpJ+yrcYXJL7Z7bneh2h8d9R7koEcGfEfujUNfH1m
	 Q8y8ro5noyJMDJMcJfYYNJNhDYqjuSMX9qbJJhUzmG1WRXdzEu3Xgc6bFc1gFp3/4Z
	 v/UyITFZb1FwL4YAEg59gl/L9eOrhjOujY84q5sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leizhen Zhang <lzsx618@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1186/2151] gen_init_cpio: stop parsing on lines with a missing argument list
Date: Wed, 18 Nov 2026 15:48:41 +0100
Message-ID: <20261118150205.419062299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b7296edc6626f..0f0c61ec21ca3 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -756,6 +756,7 @@ int main (int argc, char *argv[])
 				"ERROR: incorrect format, newline required line %d: '%s'\n",
 				line_nr, line);
 			ec = -1;
+			break;
 		}
 
 		for (type_idx = 0; file_handler_table[type_idx].type; type_idx++) {
-- 
2.53.0



