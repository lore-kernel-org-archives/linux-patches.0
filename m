Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A432EE98F;
	Thu,  3 Jul 2025 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554542; cv=none; b=etPB5a6StSN1+MlBF5zBsGdOyfejCZuWzzbpjwN9Wg7RpQGYvmnDvgreEeMP0nKCWZKmzfvN4JapvQQ/po496liQJhxSgY80ASkmoNJ7KtSw+lRTUISIsABG2ngm5L2K6g/5nrF3MwzIevP/mdsetXw7jds0QGLVrxypVYQXtD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554542; c=relaxed/simple;
	bh=Hqxiiod4sMo3NFBJdmIU7rAGUAKNvCxh9jP+x1ekyxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AByfCrFvXMgT5dCzSOT2y0lbsyVb1OoCFInhTUoqWQvecnSTxedFwzHH3JGr6xVTeU/gt1ETdamPHWLlVAk8g/D9arRigOYlVL7K30acv3tA8rl3ifgxv3VHS9tME0d9uDxbsJoe2475Ji83206lRU4lozdhirTy9uy8FFGGFQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtvMa83T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtvMa83T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DDCC4CEE3;
	Thu,  3 Jul 2025 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554541;
	bh=Hqxiiod4sMo3NFBJdmIU7rAGUAKNvCxh9jP+x1ekyxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtvMa83TXdMJxqgn0ZwglWRvT1Bez18NdtyN8qZCsOcxnfSbROb7uAOmpBHOBLf83
	 E2q4xNMsvVawAcuOPLIymSyMDHEPbNSDHWZnZTukPavaCiYDc94Kk9+/Tinl88RJCQ
	 CwE2GZMmDfhe7y491phPNuUV6VE89AfRVowe4K3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Mathieu Tortuyaux <mtortuyaux@microsoft.com>
Subject: [PATCH 6.12 193/218] net: phy: realtek: add RTL8125D-internal PHY
Date: Thu,  3 Jul 2025 16:42:21 +0200
Message-ID: <20250703144003.922213606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 8989bad541133c43550bff2b80edbe37b8fb9659 upstream.

The first boards show up with Realtek's RTL8125D. This MAC/PHY chip
comes with an integrated 2.5Gbps PHY with ID 0x001cc841. It's not
clear yet whether there's an external version of this PHY and how
Realtek calls it, therefore use the numeric id for now.

Link: https://lore.kernel.org/netdev/2ada65e1-5dfa-456c-9334-2bc51272e9da@gmail.com/T/
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7d2924de-053b-44d2-a479-870dc3878170@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Mathieu Tortuyaux <mtortuyaux@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1114,6 +1114,7 @@ static int rtl_internal_nbaset_match_phy
 	case RTL_GENERIC_PHYID:
 	case RTL_8221B:
 	case RTL_8251B:
+	case 0x001cc841:
 		break;
 	default:
 		return false;


