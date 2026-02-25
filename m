Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114F42550D7;
	Wed, 25 Feb 2026 01:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983479; cv=none; b=Lf6StQq3T5OBHSuHqWJ3Yr9BMJzaK4qCFbSyiYQ3OW0KWXc6e6UA4kkrvJVpP62Bt0TLfOF/Uuprkz5QoA2elQmfgWvDhRbH/Pwac0Q8s8L87eLHg9zR8wF6IYj23JIQq3T7Mf26Vq0ymy5S2URqkkOvcH472zPpAcz1VKlVrXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983479; c=relaxed/simple;
	bh=BqG6YdlFcCYCzom1hIoRdj/DKpRtIBwIu0YTqh6l8ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuJwNjfUbeEYTunbKpkLe4GxpFVRbUwbzJKhrWTlEaFtW+E04I1VX5VDIZZXFbpzHauZO7Sn4AaNzaOkzjH9iItbtXulMOsXzUMLWNB7JytuZZtLPHaTKYEbxkYyvPZyX9DF5sDNZS1wf/W5sTFLXEgt6xgEzuKBT/Re6eZbDUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOTNIDEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOTNIDEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36C7C116D0;
	Wed, 25 Feb 2026 01:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983479;
	bh=BqG6YdlFcCYCzom1hIoRdj/DKpRtIBwIu0YTqh6l8ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOTNIDEnDQTW2/969/j/CRq/LKlXxMU1Lz9mHfnAcZIpWo6Lo2Hd9R8XcCdwBXQjs
	 owzAPlPhCL9R9cnaqBIZrD7mJEeRVmHO4uNbChuF7fK0lhFI7OX5lKHs8RxijdTP1K
	 sd2BZvk7REyRFlgz8uI2aFcVjBSzZqJraKhquIPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 575/781] stm class: Kconfig: correct symbol name
Date: Tue, 24 Feb 2026 17:21:24 -0800
Message-ID: <20260225012413.903533381@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ed1613fc18834b5ec38d3534e96e4bc990289aa2 ]

Drop the leading "CONFIG_" when referring to Kconfig symbols--
it is supplied by the kconfig software.
This make the default values work as (apparently) expected.

Fixes: a02509f301c6 ("stm class: Factor out default framing protocol")
Fixes: d69d5e83110f ("stm class: Add MIPI SyS-T protocol support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20251228190502.2480758-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/stm/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/stm/Kconfig b/drivers/hwtracing/stm/Kconfig
index eda6b11d40a1f..cd7f0b0f3fbeb 100644
--- a/drivers/hwtracing/stm/Kconfig
+++ b/drivers/hwtracing/stm/Kconfig
@@ -13,7 +13,7 @@ if STM
 
 config STM_PROTO_BASIC
 	tristate "Basic STM framing protocol driver"
-	default CONFIG_STM
+	default STM
 	help
 	  This is a simple framing protocol for sending data over STM
 	  devices. This was the protocol that the STM framework used
@@ -28,7 +28,7 @@ config STM_PROTO_BASIC
 
 config STM_PROTO_SYS_T
 	tristate "MIPI SyS-T STM framing protocol driver"
-	default CONFIG_STM
+	default STM
 	help
 	  This is an implementation of MIPI SyS-T protocol to be used
 	  over the STP transport. In addition to the data payload, it
-- 
2.51.0



