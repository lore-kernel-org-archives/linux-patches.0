Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8D53EDE40;
	Mon, 17 Aug 2026 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976197; cv=none; b=MZJHzO5aJXlhRC86DYO1uyDVBwD7dkgz86hMaLuDUf5z/RyVBm/RxvvsIV7c0wE+2HAQDxeqUk3f7piGCnaABkoz05EMIVLAofBrHMlBKCV68NfDfZDaPiUm4EFxq+T/vz0Wup/eheYaqQK2lwbryoaX9eTw9PmaWvSfS212Kmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976197; c=relaxed/simple;
	bh=dk7Rwx9Ay2clV0b4U63YCA2jJXOzzUIfx/y8mW/YsHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsWU0lD0mUlYgcYm25NyDeoOVoQZHE+ybwenp5j4HDxHWszjjHrJsL5supp+2Dy1muwt+L0D04MVefspGQljUbV0ls+GQHUpJfDIoN5ZinYYY69wE1qOCj7fk+1QeOkHB+XXcA4tB9MpBkOU06JLIkQSfSEuJgTKdDULqZle/uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5Cia3jo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5Cia3jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D811F00A3A;
	Mon, 17 Aug 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976195;
	bh=bE2KKOlz6dgSfYxDiFpZgt5sLG1/sVXxPXkL+fdTzqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5Cia3joH6hhj++VDxfw7iCh/DbgVof3VS7q3+rWx9js63rTNKVyQ5pOgmUeujuNF
	 Ftg4dTKLeKahnR45HQN+jy0m021gUpssg20kSsqJC9dH1uEXE4l9h4JGzHQPR6nPio
	 q4lfzVWSiXLYfDJQCo4BneDraAtaTv4NxARh0kXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 291/389] can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer
Date: Mon, 17 Aug 2026 15:32:10 +0200
Message-ID: <20260817132550.430484558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit eb96c58907922546e415e545fe9a14ea63b02719 upstream.

Zero the allocated buffer in j1939_session_fresh_new() to ensure it
contains no residual data.

While there is a potential performance impact if users allocate maximum
sized ETP buffers, most real-world use cases are not noticeably affected
since the maximum known buffer size is typically around 65K.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Reported-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Message-ID: <CAPAUci5dykCLjoijqkUtFqJFesgncrD7+S6y_V=gjbFkY2Tifg@mail.gmail.com>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260728055835.1151785-3-o.rempel@pengutronix.de
Cc: stable@kernel.org
[mkl: add Message-ID]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1546,7 +1546,7 @@ j1939_session *j1939_session_fresh_new(s
 	}
 
 	/* alloc data area */
-	skb_put(skb, size);
+	skb_put_zero(skb, size);
 	/* skb is recounted in j1939_session_new() */
 	return session;
 }


