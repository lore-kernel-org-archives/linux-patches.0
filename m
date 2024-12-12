Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E6E53365;
	Thu, 12 Dec 2024 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023674; cv=none; b=LTBh6kSldmMcosDbNe9ZsvER6lRzRQD8BDlsf3l2yTiuATxLk/D9P0Ui6qxpCl5nCgiRZ8slC9xRHtk+OoDr0b5ElPrOtLTIOztcsxe2M9Gif7mxEXAGnfISKPgLOTWm3g2yyNQxvyV1u6BCiawdPFdXDpYC2hLs3HEIxKhZRzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023674; c=relaxed/simple;
	bh=BM5E1arpKZKeH5Cx79f6Q5c/5mW6N54hOTN4APRXKmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XravTOCii21X/x69VjKj/SaCzNvU7r2LD/gMNxl+YMAYynRgEFgTbpXXJrmR7ycxgAWBqjdVqSQPuNhbLzyL7K8KCuR9rLcIJOKKMqwUWRPNknBCWZ8B76kTzu4fvk6nhXAOn0oRONX1Mze5hwUTQC7ph1z/BLM81A7WMZ1ykBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXMvfBiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXMvfBiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12854C4CECE;
	Thu, 12 Dec 2024 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023674;
	bh=BM5E1arpKZKeH5Cx79f6Q5c/5mW6N54hOTN4APRXKmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXMvfBiUt3A8l+DMg5i8AoXstohAGg1fDIskUyZJCbjXHZdpSTDINaPW2Hz+MHY0D
	 9E69xc+zT9R1K3N7ngHFBKfsjG+JziwmLMwjqnaBmXrNsNXZctltlAYrTc+POG/NTb
	 dHtYfHVnnxo4lIIoOaV38eWNAnljzt5U8LOq/OnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/459] can: j1939: fix error in J1939 documentation.
Date: Thu, 12 Dec 2024 15:56:22 +0100
Message-ID: <20241212144255.266764869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0a4b73b03b997..59f81ba411608 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -83,7 +83,7 @@ format, the Group Extension is set in the PS-field.
 
 On the other hand, when using PDU1 format, the PS-field contains a so-called
 Destination Address, which is _not_ part of the PGN. When communicating a PGN
-from user space to kernel (or vice versa) and PDU2 format is used, the PS-field
+from user space to kernel (or vice versa) and PDU1 format is used, the PS-field
 of the PGN shall be set to zero. The Destination Address shall be set
 elsewhere.
 
-- 
2.43.0



