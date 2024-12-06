Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC8545BE3;
	Fri,  6 Dec 2024 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496497; cv=none; b=HWXbtntqhcdiRat/ogskgYz606QHgrRwzoq2wjL9V6Z3zEcRHOaOufuuUwqu6pCnzTKSvXYSOT71thKNfUbGVE6EnOJVP4YB5wdI0SrFB1mYIBM/fzlAOaf6knRc+D8OCE+rbeLpQvg0SMwdPzxCZArdgBtxLX7Ee+W1VVLT/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496497; c=relaxed/simple;
	bh=3dDuUTDq0XWhjIeQ3e6FcN7rfe+//t1NvXwSvCWi/ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FAm1lITBe9tq69IrSsqZlSK7S4iJeZZYHdx3dP1N9eO+AR388d3AdTQK0GO4if3CQZjKHPQW4Jz9Isk4DLAbtaypmGZzKhcsqTMXSkg4jxqbjtBlBaM4tGwihnoNqhm6bi8jeqMkWaJ/MGJjAglymk2lcFY2cqJ8y9z4y4ulk8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YeXNyCBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeXNyCBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73929C4CED1;
	Fri,  6 Dec 2024 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496497;
	bh=3dDuUTDq0XWhjIeQ3e6FcN7rfe+//t1NvXwSvCWi/ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeXNyCBsXWst8fUNrHWUg3BDnd5/tOq6WY7LZEkz5ClULQ3pgy6ZsQrfHFEZaFOlP
	 ALVxfbyeJ6sIe4ggF0XfDbHDQ+R2Xtd7i0RxlpqMmHWt3/Kqihgc6Qq1WuuOZjl5Sx
	 ZIK+IGDgFBBbOE18QirgtR4bdxIDgLnQgowrdJa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/676] can: j1939: fix error in J1939 documentation.
Date: Fri,  6 Dec 2024 15:27:21 +0100
Message-ID: <20241206143654.226605945@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Hölzl <alexander.hoelzl@gmx.net>

[ Upstream commit b6ec62e01aa4229bc9d3861d1073806767ea7838 ]

The description of PDU1 format usage mistakenly referred to PDU2 format.

Signed-off-by: Alexander Hölzl <alexander.hoelzl@gmx.net>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20241023145257.82709-1-alexander.hoelzl@gmx.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/j1939.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index e4bd7aa1f5aa9..544bad175aae2 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -121,7 +121,7 @@ format, the Group Extension is set in the PS-field.
 
 On the other hand, when using PDU1 format, the PS-field contains a so-called
 Destination Address, which is _not_ part of the PGN. When communicating a PGN
-from user space to kernel (or vice versa) and PDU2 format is used, the PS-field
+from user space to kernel (or vice versa) and PDU1 format is used, the PS-field
 of the PGN shall be set to zero. The Destination Address shall be set
 elsewhere.
 
-- 
2.43.0



