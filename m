Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437BF12AAC6;
	Tue, 14 May 2024 11:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686616; cv=none; b=UUJG1wubmiyaA8FpICJhowiQqXYHdlmaKhzA6ZnEycaRhY42zNvkgO6od4iIqnIz7Iym8ZFIzvGJSWo002r2+fkd1LmdXh8+b2OYRoqc06GEFX+1gAG7ccHq8Arru622RdBv1Yn65PHPkuIKMWKgp0lS6G0xgfmUGu8aFk95XT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686616; c=relaxed/simple;
	bh=VWzJtq6is/JpTo7EYt2GxWzF7Mpk4zDpURFx6O1yyCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gny0kAUPN0sNpyPfaUVvcgf9VOxeXZCG4HIgdvpmc5153YMfocS43+qHAZMfVYNkwmYwqWWgMjiIdNbCtYrPHM8NtsQKlz51coojRkJ0fItJ7pnH58cZq99nQGOX4C7ie0DSs1KTJ6WtffQ43kjt5gkcOKrsR9PFKD7UXGK2NZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORHMXWiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORHMXWiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C418DC2BD10;
	Tue, 14 May 2024 11:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686616;
	bh=VWzJtq6is/JpTo7EYt2GxWzF7Mpk4zDpURFx6O1yyCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORHMXWiKZy/a5RMFGkGZuWIuyvmOCyTuu6+3Gab+bah//5gUv7xV3WUm5Du0o7yDV
	 7pNJk289zvmc5vKG3jetP0Txbh5eXOgenctUO+34uW/aCyI8S17FQBb0Wujv7zeLmT
	 EwvMX5WNiRJDSpT2qPdGkIgMcyDSjJGQlytxvO0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leah Rumancik <leah.rumancik@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/236] MAINTAINERS: add leah to 6.1 MAINTAINERS file
Date: Tue, 14 May 2024 12:19:04 +0200
Message-ID: <20240514101027.268108476@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leah Rumancik <leah.rumancik@gmail.com>

I've been trying to get backports rolling to 6.1.y. Update MAINTAINERS
file so backports requests / questions can get routed appropriately.

Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ecf4d0c8f446e..4b19dfb5d2fd4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22557,6 +22557,7 @@ F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
 C:	irc://irc.oftc.net/xfs
+M:	Leah Rumancik <leah.rumancik@gmail.com>
 M:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 S:	Supported
-- 
2.43.0



