Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEB72C9D;
	Mon, 23 Jun 2025 21:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713676; cv=none; b=sxjZMZ9XYEEQcpkzf9iFf7E1BHK1kbX5LBzbuFOWFul5AUwqMxnJYXur1zDHYE+7qinHMopp2RV5sJ5K7Zpyx0Jw5wjM4YIdqZJqWvirvzvBX4kxfgZQ9e0FCauSWYs/rnAacoYW65T6yJU22rqebWg4LVNbVRcVI8ga5vNZVMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713676; c=relaxed/simple;
	bh=7a1qna6USIWE9s3w0dJfmBqvR7DoV++nd9kOyeIxDrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUs3EziKEbTfYNKeSbTFUljsrezP8ppR4tia2CEKxoFGHpDP1XrbXgH0i8Bnyek/Ay23f7TBlOy5+BoZl6p2XoGebp8y/8koA5aVEmnl+CTIVk9cexl3tTnR9+lVUtl+utNpBTMXa3T1UdX+tXOHDYdb52mA3G/a7W74vNYQ8M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njo/ndi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njo/ndi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A2EC4CEEA;
	Mon, 23 Jun 2025 21:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713675;
	bh=7a1qna6USIWE9s3w0dJfmBqvR7DoV++nd9kOyeIxDrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njo/ndi98q5qNTenaEF0FVBVJYeqqb50W/a8nnHOI4n37W0Vj6PDw8Ous2emrV0pb
	 m/jftUKnSKAyNlaq8qm7JNStQrEoP5J3nEJOLeP0+CZ3RuEzuIpx7vOMzcAwUuJ6n2
	 7hU6Rf4PuRJSFXiaHu/Q7fedWhq0WBVkyblzgyRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 073/290] net: ftgmac100: select FIXED_PHY
Date: Mon, 23 Jun 2025 15:05:34 +0200
Message-ID: <20250623130629.188655289@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit ae409629e022fbebbc6d31a1bfeccdbbeee20fd6 upstream.

Depending on e.g. DT configuration this driver uses a fixed link.
So we shouldn't rely on the user to enable FIXED_PHY, select it in
Kconfig instead. We may end up with a non-functional driver otherwise.

Fixes: 38561ded50d0 ("net: ftgmac100: support fixed link")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/476bb33b-5584-40f0-826a-7294980f2895@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/faraday/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/faraday/Kconfig
+++ b/drivers/net/ethernet/faraday/Kconfig
@@ -31,6 +31,7 @@ config FTGMAC100
 	depends on ARM || COMPILE_TEST
 	depends on !64BIT || BROKEN
 	select PHYLIB
+	select FIXED_PHY
 	select MDIO_ASPEED if MACH_ASPEED_G6
 	select CRC32
 	help


