Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BB42C2364;
	Wed, 10 Dec 2025 07:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351994; cv=none; b=JHNYraOPOUSeVmFTXSj9beF9qNwKg++S8yO2D7RLahd0sB3D6bt0PVQd+RoVORXSjePHB6WxlbMwdHzp1/awzTS9ukR7hK6GKUrJvvk8a86CcY2pn14iQCnhvvBRHCfzEWAJtChF87eoTE9VMH/zFhBh/+FDoQENeUsbe7lJk4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351994; c=relaxed/simple;
	bh=RR69SduN8DoLgD/hZdvN9tdEUiYqAoT/eZlqJgMMa1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXy4/2cbipC8kWA6P0Ja5HcojI9oVw7cYMnP1jxks5jhqNFogqu4ihcEObBvf5qUhwyzv7ddiO6xYe/sgqJO65/xOra0ZKT1pcU9gcn1Tzp532jHCIaTFiCAOn/fjt6bgF5UFQcLrHHu53YuOnkvEYAvDGL8Q/9KBqb3LAD9aVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQwTvTUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQwTvTUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D006C116B1;
	Wed, 10 Dec 2025 07:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351993;
	bh=RR69SduN8DoLgD/hZdvN9tdEUiYqAoT/eZlqJgMMa1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQwTvTUPvpjLtVHhF6PkYOyASw067BLuSrYAX87aHGDXzxWHrnZT35Kb8ZleLwneD
	 tJHR+2oqjupbFHGG38AOO4t9iv7ndjs7ObaifAEDubYGA6utZYLILNKPYvYRFG2BMl
	 5UoHwCOQcSzPlV4wEfFO1t5cOhfMxtkfwlMMAF3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.17 01/60] Documentation: process: Also mention Sasha Levin as stable tree maintainer
Date: Wed, 10 Dec 2025 16:29:31 +0900
Message-ID: <20251210072947.884973422@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

commit ba2457109d5b47a90fe565b39524f7225fc23e60 upstream.

Sasha has also maintaining stable branch in conjunction with Greg
since cb5d21946d2a2f ("MAINTAINERS: Add Sasha as a stable branch
maintainer"). Mention him in 2.Process.rst.

Cc: stable@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20251022034336.22839-1-bagasdotme@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/2.Process.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/process/2.Process.rst
+++ b/Documentation/process/2.Process.rst
@@ -104,8 +104,10 @@ kernels go out with a handful of known r
 of them are serious.
 
 Once a stable release is made, its ongoing maintenance is passed off to the
-"stable team," currently Greg Kroah-Hartman. The stable team will release
-occasional updates to the stable release using the 5.x.y numbering scheme.
+"stable team," currently consists of Greg Kroah-Hartman and Sasha Levin. The
+stable team will release occasional updates to the stable release using the
+5.x.y numbering scheme.
+
 To be considered for an update release, a patch must (1) fix a significant
 bug, and (2) already be merged into the mainline for the next development
 kernel. Kernels will typically receive stable updates for a little more


