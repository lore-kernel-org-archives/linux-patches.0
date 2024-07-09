Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F208158D86;
	Tue,  9 Jul 2024 11:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523772; cv=none; b=iBVwGfYRzpn4fDG1H5NqtNStmrCteTb65lE2DtmTlZX88YzehvNUG7UkJto2L6ItxVT4+Y9l2yPZ8biq1SfmYlSAPnm3IWYsQb8hyA7acKSs8FE48cvHybeUyr4BgPQEraPwfTBaCJGP2rRn5V885gKNltAQDRJZ6sZdbROLE1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523772; c=relaxed/simple;
	bh=UBR4UFmSbBBtzmSC8UGxoA8Olirv7+130IXTj2HPf1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly/gjEkV8kvm8DPv1kBRkMAadHVv7eJ5RevHn7afK5zA6RwAG4jMk6ekpMrsuT1eCZcqu3J3R3v8db87E+LuTroOYoGokP+LAU93WDIGzNhNo7gWMt5XZi9Sye90LaX/QZjL3xPnZ29hTqSXGBsmqZeil+XeGDmx31YIbpH1KJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1wWJ02p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1wWJ02p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3A3C3277B;
	Tue,  9 Jul 2024 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523772;
	bh=UBR4UFmSbBBtzmSC8UGxoA8Olirv7+130IXTj2HPf1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1wWJ02po8fe8eQru2BDj/5FZATaIV8p1pabkR39tJyNPFlmD1fIS6y9IV0BccQUo
	 kVLhWcAzluE22O3zzb6mtAfBtZH8B0JTuJiehuW4tGB6u9d8GjlO2qjFbhf9Gm5ky8
	 YZeYDSKc8sNtQvVvYCUcV6KyCzuxF90DDeUh/pHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 103/139] drm/amdgpu/atomfirmware: silence UBSAN warning
Date: Tue,  9 Jul 2024 13:10:03 +0200
Message-ID: <20240709110702.158450998@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d0417264437a8fa05f894cabba5a26715b32d78e upstream.

This is a variable sized array.

Link: https://lists.freedesktop.org/archives/amd-gfx/2024-June/110420.html
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/atomfirmware.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -702,7 +702,7 @@ struct atom_gpio_pin_lut_v2_1
 {
   struct  atom_common_table_header  table_header;
   /*the real number of this included in the structure is calcualted by using the (whole structure size - the header size)/size of atom_gpio_pin_lut  */
-  struct  atom_gpio_pin_assignment  gpio_pin[8];
+  struct  atom_gpio_pin_assignment  gpio_pin[];
 };
 
 


