Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057095;
	b=b2ey9+MT3R66301f8f/KYg8XoNzhyfgQkLt/x/MvuwiX1bHH/7OBvs5wWznvh/wnCIVb
	 l9umBv42+vzail8Rr0mrdqk+JyIJZGMrblZsj9IZCvplco8XK0BhuHQn1j6K42Dk33PO9
	 hPL9WKez1fTBp/K9JgFrhT1exenzLOuNfYr8AMenaWdotQNhvFn/twqw1rXuiYce1FDfu
	 L7LQtWq+EmM2x9mfQyhepqyY9mEkkT3dAGKuezOKjuwEyJzYqlLRrEmJy1Z4giNasilzP
	 70sh04hD1Yq9AnIgGdBtRB6IYRp5H3cG1CR+79qJyJKd3DHdDMAi5QVHD6yDj5NtegQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ti4jl4n7RejlS/pkC16/WC78m2m+kpHvVTvp0sFvYA=;
	b=5BboJTO4q8EbvkqRrBJvEUfCohbs+ca37/X8Yc9UHwgzQ79WHGqXn9BVn2eMr4YGjS32
	 ibs9rbtuA7P47xXqMQRAsXLkovwfWJmMnmjs9qI/nJEYXO7ePkW3KRzkRj3GHNQheUoyj
	 ilCk9q0xpv5woXkyLz0i4oQbZk700Y7icLTvKnn3eXc1d0FcvYyVgP946kuaIbVyIIOQZ
	 3mJCn0ALxPnbN5w7FuGMS7amKgrZpAEvyxvB080Ku39MODSAwwEm7XS1G4k7HshQrBj7r
	 i9qEM5loMqol5xGv7rOcl595FN9ZBJGCZnjrEr7Q4lCR6ir68p/cbsdNZxqZtiikMJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UNreOr/j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F8C606A31C;
	Thu, 19 Nov 2026 02:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UNreOr/j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131781F000C4;
	Thu, 19 Nov 2026 02:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057095;
	bh=/ti4jl4n7RejlS/pkC16/WC78m2m+kpHvVTvp0sFvYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNreOr/jwuUs3MPa92C4YHbGQonkSSmQ1n1+i1SUwL7qHiDKkboy+iRGhHbCXGFID
	 fxbIjSfkW+jxUKNpmERsthm+V8sgjFcw0wHt3/EbrwsScnhfWWvIYiUT0A5JYbgZTi
	 mnHz/rYksoP5BXqeddxJA63oBCE2spHVWORyNq88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Kalesh Singh <kaleshsingh@google.com>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 2209/2214] tracing/histogram: Fix documentation inline emphasis warning
Date: Wed, 18 Nov 2026 16:04:45 +0100
Message-ID: <20261118150138.623814262@linuxfoundation.org>
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

From: Kalesh Singh <kaleshsingh@google.com>

commit 93d76e4a0e0112b320c4f0e2a3930ad634628c58 upstream.

This fixes the warning:

Documentation/trace/histogram.rst:1766: WARNING: Inline emphasis
start-string without end-string

The issue was caused by an unescaped '*' character.

Link: https://lore.kernel.org/all/20211028170548.2597449-1-kaleshsingh@google.com/T/#m77da47432f5cc6521d4294ffdb9621949cc35d04
Link: https://lkml.kernel.org/r/20211028170548.2597449-1-kaleshsingh@google.com

Fixes: 2d2f6d4b8ce7 ("tracing/histogram: Document expression arithmetic and constants")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/trace/histogram.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -1773,7 +1773,7 @@ using the same key and variable from yet
   # echo 'hist:key=pid:wakeupswitch_lat=$wakeup_lat+$switchtime_lat ...' >> event3/trigger
 
 Expressions support the use of addition, subtraction, multiplication and
-division operators (+-*/).
+division operators (+-\*/).
 
 Note that division by zero always returns -1.
 


