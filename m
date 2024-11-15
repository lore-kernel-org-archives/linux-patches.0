Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92212EAD0;
	Fri, 15 Nov 2024 06:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653252; cv=none; b=q3yZs7u6JGBu6Wfw5uxpvDzgWNxi22s9boEWkXz5a7YIvd9ByTLzignkF2yn4nIXcOvb5x2fvzSeQ/xHfZtnjvQROKG3jlpAOwIugDnbKsagpRM09CYF0a3hC49Miya+ckbiBGkiSFeTEijSCsjaE8aO9SYq9qj24piPWMf0T+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653252; c=relaxed/simple;
	bh=0UfrvSPWRNxAk72Ev0P145nXX+Xb0o52eKUVV39ra08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDmyTXQl9wS8AkZPogfTvuue804xIHeb9OtQqmVae6CSlhxn2zUI6Gbg+wQFMPdsJ5tVLyQRvpPQx7w9D3iguK3r0mTva2OxVzDGwkMzG/JwE3CmW5FQQ1iS9XKpfbK0k21AUaNzrYLrlrIXW3RcMkZ1y520+z2W8XCzoTvwn+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrfOShkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrfOShkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EE0C4CECF;
	Fri, 15 Nov 2024 06:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653252;
	bh=0UfrvSPWRNxAk72Ev0P145nXX+Xb0o52eKUVV39ra08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrfOShkG3YTqpcPEZSHtz230gi5CmvoMmSJ2F+dpc+svWxPHZngZ+eC5JfeljcqhQ
	 FD3fkSJ7MFJIKI8AkSO3SgQwVwH3lFW6b/UwJm8WmAbi6JlfdKZkG/3LMMzm7UHdQn
	 8kW+48yfakSOuCNW4eN6787YOtI2TVyX571I2UmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 09/63] pinctrl: intel: platform: Add Panther Lake to the list of supported
Date: Fri, 15 Nov 2024 07:37:32 +0100
Message-ID: <20241115063726.233938725@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 37756257093bf1bda0bb034f4f1bd3219c7b2a40 ]

Intel Panther Lake is supported by the generic platform driver,
so add it to the list of supported in Kconfig.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/intel/Kconfig b/drivers/pinctrl/intel/Kconfig
index 2101d30bd66c1..14c26c023590e 100644
--- a/drivers/pinctrl/intel/Kconfig
+++ b/drivers/pinctrl/intel/Kconfig
@@ -46,6 +46,7 @@ config PINCTRL_INTEL_PLATFORM
 	  of Intel PCH pins and using them as GPIOs. Currently the following
 	  Intel SoCs / platforms require this to be functional:
 	  - Lunar Lake
+	  - Panther Lake
 
 config PINCTRL_ALDERLAKE
 	tristate "Intel Alder Lake pinctrl and GPIO driver"
-- 
2.43.0



