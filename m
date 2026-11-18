Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018910;
	b=FShTHTfl0xnWvNbgTYRQKQpgOYO6eIiGoTrcWW9rpRHmjzgJopjsCdTFPjZiEjRF2KxT
	 3Njnc+BjHqU3KzxE+0u+Di/Ex+N8jBlc521faSLL6faNYff0l8qXEubxa2yxidjlClQSw
	 I7cL0WdpbCtWw130mTiNWwNnmje+WPMqXCa+3TzRF9mq0ogE0tP9Nhg34G4D9r62uYJ2/
	 f8/6HrlpFMrdrrFLwWA+RGZiUxKqCG3NKbw8AN/L6g+8gUzyMTYicKsIq9eQY5BI23XRX
	 HsYZgwys8/fFf/2WZZiJHDwzOZWa40Zo190PR4rPrjMTteRaqdTdm/wsLCDfkQ6X9Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v1W7pb0mu3DP69c+ZvgTWYkjuiHrF1DHUBs+XCwLWI0=;
	b=IrAN97iuUvNVUWCpWDr+XQnU9L5CYW6HnO04bSzhY9zO8vYPukVqAdW0bZqXc00XGq9D
	 CA02Bo1HKpacjqjWPZgzs9uBrRFHSmieX9HtN3B+cYKEDQ2oSSk22E9Ve2nSVSSZ7ORAE
	 P8o0kDD3j5GI/DqlcCERkrH7mnva+DQ3LZp2YhMkdpmsLY2Xl3q9X1bIuJrYjW5zhAqdJ
	 inN9UNNm9JZrN7YQU5iUglStuonZBcItEZKfo+JQA7FQmxufNJgqkGyxjJRUMO+FPPMKj
	 fwDv0DTsHlv1zzEwVPKyAAaBlMuBnKONeU3uj/x3cRiPOk8aahZfChreE3kPlVJCvRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pp8c2MTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A53606A31C;
	Wed, 18 Nov 2026 16:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pp8c2MTl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D161F000C4;
	Wed, 18 Nov 2026 16:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018910;
	bh=v1W7pb0mu3DP69c+ZvgTWYkjuiHrF1DHUBs+XCwLWI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pp8c2MTladDEEenSbu6Gd2+fuDIIyn3W2KBYCeeq8MxYzDsQpctMKbcsWiv4RqYdX
	 iHgbEU2BJqVYpyv+HFd7M8RqwBcduhPcFTfUDpB321emHOZQvrObAW0MeIMlcBLppv
	 dRR/bzN80sRy/nUszvcgSPU1iYNTUZ/Zv9fjapcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leizhen Zhang <lzsx618@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1409/2651] gen_init_cpio: stop parsing on lines with a missing argument list
Date: Wed, 18 Nov 2026 15:44:09 +0100
Message-ID: <20261118150338.736671403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



