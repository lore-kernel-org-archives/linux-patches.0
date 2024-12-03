Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408BA1F7577;
	Tue,  3 Dec 2024 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237653; cv=none; b=rRARXy1yPCXpJFwg0WWF9ZTdx5oDlTIX7yjG5cfj5dpP+2eL1stVgwLjjlXdhVjR6Liggi6RjA1qSY28NVEm7OjOrbA0XLFBpzdzNsOfYs8/K9fi/u6dosmTWZR61dplWvGfR9SWgVYMRN3Ha865spEkZ+fUyhHZIrfnYpMAX1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237653; c=relaxed/simple;
	bh=25UlqxkYvc6vFTj0+F2sUStePqcCGFtFshYGzfX5ZVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DR/jesybvIB8HV74zOQGtm+lUu5g0Es+Q6DFKzQ2X5OmmZUfM/vIX6GbMeVI3PVBMmU1k4oZ3LTQGXD5Ypq2CMbHu6f/ZkNtQspyhAPQ8kdOk87zk5isneVz6Eet1QV4jPs/Jl2NUn4id46fb9muJf6rJ1hk3wYVok28foBfsDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+7jbYpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+7jbYpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63211C4CED6;
	Tue,  3 Dec 2024 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237652;
	bh=25UlqxkYvc6vFTj0+F2sUStePqcCGFtFshYGzfX5ZVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+7jbYpSKF4s+Dkg84C6qV6hL6v4nuhCzR4+9lr/aOYabHIbGxCa8RhxwG//W2bEd
	 c9B57mYwLfAjAV3vDgyydfGubSyy9US7Z7DjJIf3gFGprRtrV+JuVXxnyAZ6m1r0xU
	 1Bd1h4Bj9aw8xLyKamT70ApQ2Q5TONOJQ7w+bIxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexander=20H=C3=B6lzl?= <alexander.hoelzl@gmx.net>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 030/817] can: j1939: fix error in J1939 documentation.
Date: Tue,  3 Dec 2024 15:33:22 +0100
Message-ID: <20241203143956.826090251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



