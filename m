Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9AF2528F3;
	Tue, 29 Apr 2025 17:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947688; cv=none; b=njYMoJ4k/7f2/OO9rbbSGavbScIKeYc8WgF4oQG1wDtY14g5gzdNSMvIx9BZDkX8IXH0/PdtA1I+JXSbLDCLuTFhIBEf6YhyhxfO7ncyik3AWkdXom/gvFisGZIEoim86UEliOLAP/gYyUs66YXw9/KcNyRxBYb5Uq0ZkrBNX7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947688; c=relaxed/simple;
	bh=Qrqmpu+oCEG1sUxIscpKSHKkR62T5G5vPhilv+yTLaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyBmfYoky2Hc/pxEm+TgndpELhB9tIjwyyE+QsgkAV0TMOfdfdIr1Eir3o+Ox3vpPpQkfmstyp/f5dSsr7ERXuC9pi3al1bSOGt81B4/Jvvo9T1qJymrPIfSO5wq1XxXW6pdzgyX+0JMbLxVcpfO8LN7fhSSkk3hzqEHv/DK4CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2sa3dUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2sa3dUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF34C4CEF1;
	Tue, 29 Apr 2025 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947688;
	bh=Qrqmpu+oCEG1sUxIscpKSHKkR62T5G5vPhilv+yTLaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2sa3dUi43rMXp1vPIqg6V4w7CTi4rDuqmBbEXYKfAZ/8Ttik2UtFECiu6A6N4kb4
	 9HOwEGTu7nX0xOX1NNpMTrB+BjZb3Wca6f9xhszVAbsUflycjZfQcZiKWVuU7hJZLa
	 a7LS86itA8wPZiBFHqhH0GKymC6f0pJakuEC0gog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clint Taylor <Clinton.A.Taylor@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/280] drm/xe/bmg: Add one additional PCI ID
Date: Tue, 29 Apr 2025 18:39:47 +0200
Message-ID: <20250429161117.002653535@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 5529df92b8e8cbb4b14a226665888f74648260ad ]

One additional BMG PCI ID has been added to the spec; make sure our
driver recognizes devices with this ID properly.

Bspec: 68090
Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250325224709.4073080-2-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit cca9734ebe55f6af11ce8d57ca1afdc4d158c808)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/intel/i915_pciids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/intel/i915_pciids.h b/include/drm/intel/i915_pciids.h
index dacea289acaf5..1ff00e3d4418e 100644
--- a/include/drm/intel/i915_pciids.h
+++ b/include/drm/intel/i915_pciids.h
@@ -810,6 +810,7 @@
 	MACRO__(0xE20C, ## __VA_ARGS__), \
 	MACRO__(0xE20D, ## __VA_ARGS__), \
 	MACRO__(0xE210, ## __VA_ARGS__), \
+	MACRO__(0xE211, ## __VA_ARGS__), \
 	MACRO__(0xE212, ## __VA_ARGS__), \
 	MACRO__(0xE215, ## __VA_ARGS__), \
 	MACRO__(0xE216, ## __VA_ARGS__)
-- 
2.39.5



