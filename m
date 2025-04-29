Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35C4253934;
	Tue, 29 Apr 2025 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949588; cv=none; b=uWEjzfZoqy6kjTdXM+2T6fUEDN7ttCvxDlvDROZaBBuEDiMy0MGaTDoHJD1GGDBk2efbFXJG7DHzXftq6eW9ihuqLqCFN9F9oepFL1oBmcCJTFEzZ3h3hFCulNS608i5ldpB2gnOAxIIKTHDrjuKgfePFp+mXQcoKtnE0syo2eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949588; c=relaxed/simple;
	bh=DqfbF0ocYrZ+dGmDyXSsdd5FLx0KHFongQhsqZHIL6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iyRoI7ZsiSwWzEL2Vg5zjnJ352XzE+cwT88UKGxyU8j2lbX0rCjicQQI6MtopBPgm41onL2IMjh6dRzFcZotEirEFrb/PdlgKrQngvyvtnL0wc4bgLnyvwJvvss80fqkLbGha7orbjvfZmBMtqH+HQbVXCjtEliJznHVb2GiKdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJ4E783e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJ4E783e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C82DC4CEE3;
	Tue, 29 Apr 2025 17:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949588;
	bh=DqfbF0ocYrZ+dGmDyXSsdd5FLx0KHFongQhsqZHIL6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJ4E783e/hax/2KUN9K3dW4XjyWwXzE7Kkn/zRWWK/KDkCpZsQjyjW4j33WUT5ElQ
	 VZDqksLNOuh0L2NESHO17RmqQpm2hnW5Ty7D2rYMWvLlRUKb6QfMdl8GKlTlE2IO2h
	 /YBGL3GBvkGU9BEa2iISOuOUELklyaT5a1P8xkR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Sasha Levin" <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 366/373] net: dsa: mv88e6xxx: enable .port_set_policy() for 6320 family
Date: Tue, 29 Apr 2025 18:44:03 +0200
Message-ID: <20250429161138.186119577@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Marek Behún" <kabel@kernel.org>

commit a2ef58e2c4aea4de166fc9832eb2b621e88c98d5 upstream.

Commit f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
did not add the .port_set_policy() method for the 6320 family. Fix it.

Fixes: f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
Signed-off-by: Marek BehÃºn <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-5-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4597,6 +4597,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
@@ -4644,6 +4645,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,


