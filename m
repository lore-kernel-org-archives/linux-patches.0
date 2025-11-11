Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBD72DC32A;
	Tue, 11 Nov 2025 01:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823688; cv=none; b=EpEPz2V1GOHvrlQZZLPP29i8JSo3m0n/esIbHkOVWn3yq8oMLtda5UIeEgMsYSyFUN5LKY/mAbpDzOilBO64AOLwd7VAzsDv9wYmx4XuEmePfNfhNr+5no8lyZ8jpVRPXcecVkB4DFpzHzmY7utpf2iYpHeHWaZGNk0/ZkEkSWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823688; c=relaxed/simple;
	bh=HJeFXieQsIzpwqtkCJD+etqEF/jslBZksAV5D2R6eoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UE2OdAKHGYiLh4+ppmzUH/+Gs5OZqolPd9T3OqRYMpKRot8LSMHKLI/S0n+ZZyq2j0uf2m0+QgiljT6k/gLpx6HKrOnNZ3h9jVwQv0vF5GVfuRaGA2pkOfrA+BjfM7Fq+CrPZ1vZFW62CagFzXeVn8gonUxnB2b1OI37y4VGvRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUgcMn0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUgcMn0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A856CC116B1;
	Tue, 11 Nov 2025 01:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823688;
	bh=HJeFXieQsIzpwqtkCJD+etqEF/jslBZksAV5D2R6eoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUgcMn0jpb7TzVmI3r6GvnST/r7f+OIT6gjW/oMOL/UBBH2wpMSsAVtzyy42Z8QBc
	 rH+BTR9VnKN9/DUf1jliFDU/KxPp2wF08KXf0pH58hr1IEqwgkUqmrPcV6/SEKhMy/
	 YgJE6ihf4gKzVzepVg7f/vjGtYH983FR/FGBGFu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 350/849] media: ipu6: isys: Set embedded data type correctly for metadata formats
Date: Tue, 11 Nov 2025 09:38:40 +0900
Message-ID: <20251111004544.881799115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit f5a2826cd50c6fd1af803812d1d910a64ae8e0a1 ]

The IPU6 ISYS driver supported metadata formats but was missing correct
embedded data type in the receiver configuration. Add it now.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c b/drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c
index 0a06de5c739c7..463a0adf9e131 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c
@@ -81,6 +81,12 @@ unsigned int ipu6_isys_mbus_code_to_mipi(u32 code)
 	case MEDIA_BUS_FMT_SGRBG8_1X8:
 	case MEDIA_BUS_FMT_SRGGB8_1X8:
 		return MIPI_CSI2_DT_RAW8;
+	case MEDIA_BUS_FMT_META_8:
+	case MEDIA_BUS_FMT_META_10:
+	case MEDIA_BUS_FMT_META_12:
+	case MEDIA_BUS_FMT_META_16:
+	case MEDIA_BUS_FMT_META_24:
+		return MIPI_CSI2_DT_EMBEDDED_8B;
 	default:
 		/* return unavailable MIPI data type - 0x3f */
 		WARN_ON(1);
-- 
2.51.0



