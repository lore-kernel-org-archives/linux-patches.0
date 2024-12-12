Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B9E6F2FE;
	Thu, 12 Dec 2024 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021794; cv=none; b=r7GdspmjHHWBOhN7ohGieqnpsUgy1BfdV79cTcQpxB35tZ6hS9OM+gvrlyfCiDnelpYZBbhrVEKp7x+lFp5Mby2YmTfPdUbw3g/rPVO45xmZSBI3Q150m7ZScomKboh43VPmQnUNSEdJ4AKEBPiecRacmxxX2RaukqvO4VGupVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021794; c=relaxed/simple;
	bh=fBGt7jhlTq/uiF3DhN68OqTvCH8ZDXGxOxyOr+78J3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=apU+89nmuLGB19l1NK7AlGgu5svowadhRtaFeNaWXMaSDgr+JvlfZJEAlL5+Felb8WOZMGOKY65TRKzhbkibReSVDwVfkzuCw1K/bJ8sSyNeApqltMsp1tr9dZtERlXyEkZGy/efwhy0sFj2WwhADRZ8eZX4h5xTIKjdhGqipyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0jIOG9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0jIOG9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C30BC4CECE;
	Thu, 12 Dec 2024 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021794;
	bh=fBGt7jhlTq/uiF3DhN68OqTvCH8ZDXGxOxyOr+78J3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0jIOG9L4X0znHBKvBSZGdXG///i+rBMAd0mQgZSF0mo8wi3r+BIxG1Al7nZW53p8
	 KvccBBRfOx7AdA5WMxmLvYy5Hg8lryrcRJC3uGAJFrTtsfk0T77peuuQXPS6zzFna7
	 FeWM4mD339Bo0D1JaUArdhE3y8tNGCY9c7PpnRuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/565] can: j1939: fix error in J1939 documentation.
Date: Thu, 12 Dec 2024 15:54:20 +0100
Message-ID: <20241212144314.063500894@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b705d2801e9c3..80b1c5e19fd53 100644
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



