Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180E4264A76;
	Tue,  8 Apr 2025 11:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111451; cv=none; b=Ti1d3dUG6yFnKNn7e2zFi/zBeSzTyvP6R5IZuxfZ547WaOJ4VXuiS5zLcopsNSSFYes3Cw6Ds0lWdb6lOacZZifirh7JW+momtplyZu/AJD4hI3v4qHSmNmuBArDuDM3iNhAPic4NvUsIVLKP4atXWGiCdkihas5Y4H1zWBBAM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111451; c=relaxed/simple;
	bh=bK4bDKuCNLFbs91s9ET/yDBH1jyLt8EwMl8211J6phA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJS/MFe2Bg5XffsbXUonFKR+YAiOPE15mLgMnE4hlJVhxmwaTsSQicMjRZ0Yy7//1WTgwpAx7l3UWYu6iAT48UlWNylkz8t5t3opKQPvVAOhLWaBMB+T7XsnSzLqEjgQkA3YVkO3TpFmhBaK7p6x/9/n39lgcWnn4/YOvmbBg9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVnJs67H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVnJs67H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0048C4CEE5;
	Tue,  8 Apr 2025 11:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111451;
	bh=bK4bDKuCNLFbs91s9ET/yDBH1jyLt8EwMl8211J6phA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVnJs67Hp/8UE/OPN+hULok8mK+A1b84p+hhPwEDzznt1qfeO7RzImW+kAWAx0gvZ
	 pI4djXYyH5rE/ycmxt9D23fKz0xM1hDd45v23GVl4hzQFn5VCSM3mqx6zicQzfopGP
	 xxzcl9I7er6Ij0EFO4E0QOuO3gXUWnGMKQF823Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 436/731] staging: gpib: Add missing interface entry point
Date: Tue,  8 Apr 2025 12:45:33 +0200
Message-ID: <20250408104924.415078874@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 2f548210a5a5d4cb5f20af39b684a9f6de58cd0e ]

Declaring the driver entry points as static caused a warning
that the serial_poll_status function of the agilent_82350b driver
was unused.

Add the entry point to the corresponding interface structure
initializations where it was missing.

Fixes: 09a4655ee1eb ("staging: gpib: Add HP/Agilent/Keysight 8235xx PCI GPIB driver")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20250122103859.25499-2-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/agilent_82350b/agilent_82350b.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/gpib/agilent_82350b/agilent_82350b.c b/drivers/staging/gpib/agilent_82350b/agilent_82350b.c
index 3f4f95b7fe34a..c62407077d37f 100644
--- a/drivers/staging/gpib/agilent_82350b/agilent_82350b.c
+++ b/drivers/staging/gpib/agilent_82350b/agilent_82350b.c
@@ -848,6 +848,7 @@ static gpib_interface_t agilent_82350b_unaccel_interface = {
 	.primary_address = agilent_82350b_primary_address,
 	.secondary_address = agilent_82350b_secondary_address,
 	.serial_poll_response = agilent_82350b_serial_poll_response,
+	.serial_poll_status = agilent_82350b_serial_poll_status,
 	.t1_delay = agilent_82350b_t1_delay,
 	.return_to_local = agilent_82350b_return_to_local,
 };
@@ -875,6 +876,7 @@ static gpib_interface_t agilent_82350b_interface = {
 	.primary_address = agilent_82350b_primary_address,
 	.secondary_address = agilent_82350b_secondary_address,
 	.serial_poll_response = agilent_82350b_serial_poll_response,
+	.serial_poll_status = agilent_82350b_serial_poll_status,
 	.t1_delay = agilent_82350b_t1_delay,
 	.return_to_local = agilent_82350b_return_to_local,
 };
-- 
2.39.5



