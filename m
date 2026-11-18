Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049285;
	b=qBuafqM10XKD9p4yDV9pZlm9b0Ov4/H+q+GFjURGIswT7AwbOtiPdp82Z2MD2fQCtObC
	 CeEuRX815UvmykwkTFS0cMil37jTJfZNu/wQWMpqXVdhA8VbOy3zbWaRUTDHDNLjV1gPg
	 8Vbow3sn1qiHy1S6eehIlghdVtX66l5AQybIAbdALgQu/acQzjiQUzr2TyLjeiAbzY5Gs
	 fdQQ8c5bG+kXmZ3ZKLZ/cq0BZ2KC9YM/noIsyiDfDSY4q6HREIiWT6yyo/LCTAfITyVxO
	 Wy1JqyYIQwHNbf8oENzeqKHMuInDIv0w5m9yfHASj7hC1TQnjOFrp+2+Gw1eZImJ33A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QqB/J1A4TmtR7UKJkVPb34vOqNoeF4809YqNGYBzUjg=;
	b=WjWh6ZnYDfZVuBd1Ad0oZhP2Y5mKN67vUilTfmXW+Nxm91D8VKzoao2i8hW8O8GTdr4e
	 Q3t1OTy5f7uaP6GtaPG9NFzQC0L96N9a/xjdNqu90o87IH8XXKqIYQALJyv2hdIz3Voh6
	 JdpwOdRkpilYjTLzO7GkGyz7ThZZx9Tl4P0ZA9rQFwrSnqnG1/Uic2/4dhxPFdmNHlHxQ
	 6RHZMKnA/eT53yEWijN7CI2FZGM9qJxHrgNtYR9DRpsuw6OuhUZfatnRMqm6D9elm41wJ
	 AlmqHbbL9cKhS7EQQy6eV0Ej3HLZ6YOOhBo4CWrMUKy8gMY6UnLRAEQrvb9yC5UNryw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqgYSyE+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F799606A325;
	Thu, 19 Nov 2026 00:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqgYSyE+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03C81F000C4;
	Thu, 19 Nov 2026 00:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049285;
	bh=QqB/J1A4TmtR7UKJkVPb34vOqNoeF4809YqNGYBzUjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqgYSyE+93Vl7/QeoQNtI38kLVkpvBkDO9RJey37ilTocFykHNIv3FDbhewfE9cy2
	 NCAes9Gl0SKh5P/Ky0yKZSCUX6tjUXAMe3XMUBGIbMWULaJaTvBcKzV7P3pnqwvD2y
	 OWVq6UcEdaTFbPQa7q45UCGhu1v9PJeFcwESAesk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leizhen Zhang <lzsx618@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2297/2857] gen_init_cpio: stop parsing on lines with a missing argument list
Date: Wed, 18 Nov 2026 15:55:31 +0100
Message-ID: <20261118150324.189376197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee01e40e8bc65..5e51e5117a6c9 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -657,6 +657,7 @@ int main (int argc, char *argv[])
 				"ERROR: incorrect format, newline required line %d: '%s'\n",
 				line_nr, line);
 			ec = -1;
+			break;
 		}
 
 		for (type_idx = 0; file_handler_table[type_idx].type; type_idx++) {
-- 
2.53.0



