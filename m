Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033345;
	b=N7wM+IO34tGQLun4WeXY1cUV1TnVZwcQ3pDEk1thsX4YzB0PLYgkH0AAh9iU4/V5cktP
	 Oq7R3a9F5uhIDq1aRsP+2YrKN6K/TQtugUaoOYpTn2uX7SLqmwuS6HufkhWWdFjMRQ2bW
	 9Q9NmR8mefSwqrWpge9moJQcrchl9wlkUJer72KAVMT/r4dtlhWRy0xpo6yP1lEW61VYj
	 gI3u6d1ZPjRQf/cuPmgIFnD06UAnOFgKWSq465PRJH0li4FeM3SRoPP3h/7VA/a0bwo7f
	 NuSKZLEa09/cjbm+fAql1vnN90JV0De9LGs5TWX2nTEzUI/l6IaRURLlZ5VvrfYbuIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MPRlwY3Vi7BDlSstC5IogQwhkLZJUbDHTkzfs0E8BT8=;
	b=sRx8nq2fw8uSNMSMmDhSTFUGItR2gVxygixseJMYwabHPafzr9SoOkhjSe0cHmNoUsQn
	 4SpqvQXX2/yDhTwkk/K2fKMGa7e+X1qnMRfXEFyv9I+hwsEF6cXzhD+4zo1XANGlVmnan
	 NDNEBArTS9et4yY/yST2YiK3koG2lBcLmUGiAvdo8LM7H2m6oBnEEUWq5Qfs/jcWUfRmP
	 e4IYjwPQyo4WsgZyHU8RkQ9BJRHf+8/y9uR+ZDo+zW9tOqryZhbXu4PB6oIgNdfySSgDT
	 oGKKE03P1VuidHfMtgfFbKljeMLeEPRL1VwZwmOvgddxMuRLd/H7+hgmv/CYlFDWbrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYNQQMO2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA103606A320;
	Wed, 18 Nov 2026 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYNQQMO2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C63D1F000C4;
	Wed, 18 Nov 2026 20:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033345;
	bh=MPRlwY3Vi7BDlSstC5IogQwhkLZJUbDHTkzfs0E8BT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYNQQMO2BSNg9On0dUmR6HbssosSFiGOMqzf1p6REP9Tyi5oXNDIln1LDFkfPidzg
	 JXOcJCik6MOK1p3ZjMJENOJdkAp8lUmVlEeOjilB8k/cgc8CuS/RIVC1eB3WjLUF63
	 XIdsqxVlkCIWigdaY6mWJbGawygIAnI6iOg7hmsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 1734/1756] phy: freescale: fsl-samsung-hdmi: Fix 64-by-32 division cocci warnings
Date: Wed, 18 Nov 2026 16:04:21 +0100
Message-ID: <20261118150118.594334699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

commit 739214dd1c209e34323814fb815fb17cccb9f95b upstream.

The Kernel test robot returns the following warning:
 do_div() does a 64-by-32 division, please consider using div64_ul instead.

To prevent the 64-by-32 divsion, consolidate both the multiplication
and the do_div into one line which explicitly uses u64 sizes.

Fixes: 1951dbb41d1d ("phy: freescale: fsl-samsung-hdmi: Support dynamic integer")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412091243.fSObwwPi-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Link: https://lore.kernel.org/r/20241215220555.99113-1-aford173@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/phy/freescale/phy-fsl-samsung-hdmi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
+++ b/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
@@ -483,8 +483,7 @@ static unsigned long fsl_samsung_hdmi_ph
 			 * Fvco = (M * f_ref) / P,
 			 * where f_ref is 24MHz.
 			 */
-			tmp = (u64)_m * 24 * MHZ;
-			do_div(tmp, _p);
+			tmp = div64_ul((u64)_m * 24 * MHZ, _p);
 			if (tmp < 750 * MHZ ||
 			    tmp > 3000 * MHZ)
 				continue;


