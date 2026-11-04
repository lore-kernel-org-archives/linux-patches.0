Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829049;
	b=30CDngtOcJzH2h2u227sJGP2lWIN4HS6rhCwu5o7t1JOLLsLDtX8zcY/FKUDpzjR+IRz
	 /HCiYfrR1U+sR2/R0wY3i+lFKi6IPqgQifkeApaHoceVOzvWVPRuZWqHfe5BH+jb9Kooy
	 63salL3AuCy64+4Enrt8DDP2H4HOIFf+aUo2+R2zaCG5ubGI7RYDUQMcTsm9RJC6T15W2
	 k3J4PCAMp3c4a2NpjIutwjau49w+4jcS+h/mbXrP+jssFMKfH2uTeOPfuJpLPhsd5nU61
	 jMJv6dBbgRElkXdkrBNR756HBTnuS6AAHgZmtFUWxh2ATnrDuJNO9LqGyE1dqszmVhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6JA/K/pF+IwjVXO5GubomAiv0mBs8aOq6Ca3jR74hqc=;
	b=X2hTFLzBceb0b6HuQR77Xq04giByyzL6fwsvxEht1eMz1RxupTKVq/TSu9wgLD0umiu5
	 3ymR2ONiFc/AtgF0th2QXQnLQc8qBfyCqzsTdn28VBxjK4Hkv8evkFhNom4FfLf9gFaTJ
	 tMxDpLY5WhBC0zxUwB1dbVJopTvAsve+JXZSKZQ6HjhIIw/VJmq/9XBY2KFZtPFJ8FUTL
	 f/aEwPhETYO4jYh4ZX+Gg8Ayac9InjlFNMSkU6x+xqskLuXn7FtZUR6Tsws8yu166aONF
	 FxynnNaNOuf9qP8aqPF+w/Er/Qb5yKP532P7zeiMrUnqOqqlEj8yTKp8jtYKzZM7aoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xm1WymIO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3281160807AC;
	Wed,  4 Nov 2026 21:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xm1WymIO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE691F00A16;
	Wed,  4 Nov 2026 21:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829048;
	bh=6JA/K/pF+IwjVXO5GubomAiv0mBs8aOq6Ca3jR74hqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xm1WymION3eBnHv6kMOBdeGwnwmd73dVsD/+1X45WDl72a/3phjHxwnmT7/KEsZzo
	 oik0dR9IbYc9oBiWGJxYftbDeiVgAXQ94qiwoz+Vnak3UMxyD1YUmaHXcxOlp9xTHq
	 BloeNj58VFnpZFEnKGgsu18nsk2KJc0+G0HlxWhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 411/547] nfsd: clear XDR padding in GETXATTR replies
Date: Wed,  4 Nov 2026 16:09:55 -0500
Message-ID: <20261104211049.995666149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit daba58690339ae86f1ebeb5197aa1369fae37e57 upstream.

nfsd4_vbuf_to_stream() uses a raw memcpy() for the first fragment of an
attribute value. xdr_reserve_space() aligns the reservation but does not
initialize the extra bytes. If the complete value fits in that fragment,
the loop that clears padding for the final fragment is never entered.

A remote client reading an attribute whose length is not a multiple of
four can therefore receive one to three stale bytes from the response
page.

Encode the first fragment with xdr_encode_opaque_fixed(), matching the
final-fragment path and ensuring that any XDR padding is zeroed.

Fixes: 23e50fe3a5e6 ("nfsd: implement the xattr functions and en/decode logic")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915160119.3105745-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -6274,7 +6274,7 @@ nfsd4_vbuf_to_stream(struct xdr_stream *
 	if (!p)
 		return nfserr_resource;
 
-	memcpy(p, buf, cplen);
+	xdr_encode_opaque_fixed(p, buf, cplen);
 	buf += cplen;
 	buflen -= cplen;
 


