Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34244253F05;
	Tue, 29 Apr 2025 18:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950797; cv=none; b=ZH/7d2qmco3a7k0QeTgT7n4KSi5NKP+skou7KJcogLJWJPCKxTrz0Ao27u7BNcK5ZDZb389Ncz8bQqkFVe16ha9bZIerZSr+HuBLnI9j65S6dCym/rPo6IGG1UJV/Q+jjqZ6uAR7HG6g68S26lPlKzibhfoIAA1ZaLHpMN9as9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950797; c=relaxed/simple;
	bh=MydhewwSGXzVaM/r3fhRCjx+VepG615wT4axk2mhG+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ao8p1Fy+7dttE6/0QqgdDLNKZJxB84/3xefX4kl3tABHL4CaaR7Hs6eHtJV9oxkEHmqfuZQnC1y8swpPzYcas/wxQy9FsvEmdVNjuRROYQL4BO4YWFx11vxlUpfvSdWIa2d3qC0AOLmL+7kTwrRu+2zN6LqUVAl+IQatqYQn1E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2w0c5cY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2w0c5cY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFADFC4CEEA;
	Tue, 29 Apr 2025 18:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950797;
	bh=MydhewwSGXzVaM/r3fhRCjx+VepG615wT4axk2mhG+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2w0c5cY+WIb6JEpmm0Q4/Vg5u78USuu7Th+JG3hNw8wiFBt3Zmu5btghQbmbF6fq
	 7T0aLWoAQeMR+XsJKYyL8Rymeb/Bq5UWof2r8V20p3HR6dv5qZUgmJewZe07Aob8sj
	 3R32ECOjun/CQb/Lzvk+EO0Ui+JIZO/NmrsWbXsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Sasha Levin" <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 196/204] net: dsa: mv88e6xxx: fix atu_move_port_mask for 6341 family
Date: Tue, 29 Apr 2025 18:44:44 +0200
Message-ID: <20250429161107.397953807@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Marek Behún" <kabel@kernel.org>

commit 4ae01ec007716986e1a20f1285eb013cbf188830 upstream.

The atu_move_port_mask for 6341 family (Topaz) is 0xf, not 0x1f. The
PortVec field is 8 bits wide, not 11 as in 6390 family. Fix this.

Fixes: e606ca36bbf2 ("net: dsa: mv88e6xxx: rework ATU Remove")
Signed-off-by: Marek BehÃºn <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-3-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5713,7 +5713,7 @@ static const struct mv88e6xxx_info mv88e
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 3750,
-		.atu_move_port_mask = 0x1f,
+		.atu_move_port_mask = 0xf,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.pvt = true,
@@ -6174,7 +6174,7 @@ static const struct mv88e6xxx_info mv88e
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 3750,
-		.atu_move_port_mask = 0x1f,
+		.atu_move_port_mask = 0xf,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.pvt = true,


