Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDBA24A05D;
	Wed, 25 Feb 2026 01:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983027; cv=none; b=Vt9q+Aa5PXVfH+o3WojilJPIXLGfvDmJVZhdM+UoNNwN1VbrGsq2RF9HoNehsME0H+7k5wDTeRkQJZ4HjwfKegDwdIwJZQdg9MTMFbe6eq2tbPwRETy2HW2uy03N1ncCMrDPBusgxGeG6rL98tyCTkxbyamt55jS6NrJ2APQeSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983027; c=relaxed/simple;
	bh=dxdHUE4nEiHsYXjetYCNv5SxtWZzXa02NtoS6QQAwDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7rpSe+tPDZCArzfybSlwfe1iFDvnlzi9GXvQO7L57ewO3S2JuCHYm8KiHZlqfMMxKlMqBMpJ9U5cSkQjnIIZ8Ndy9Po+XnPgttwrIhzuud3WaVEQgewV18o38b00xufSAfdPkdXv3ffw5FLTGTrqO29acCr0auFMkGKi8+hAy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZecTQNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZecTQNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE47EC116D0;
	Wed, 25 Feb 2026 01:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983026;
	bh=dxdHUE4nEiHsYXjetYCNv5SxtWZzXa02NtoS6QQAwDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZecTQNMiEqyiHpYI01AN6vP6u7biGgOikFYEjynyHsn/WUBDhzwd59pwhWt13xaG
	 7mkna541VL+0cJQy5HwLQWIZhbTAueHyCs5q/2szHZ3b1P/7LvbsYEYslNTcsqUfp4
	 qq5MqKEOFEyqI1l6chOC+83NHtPh6Nok74dUyXGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 192/781] drm/xe/pf: Fix .bulk_profile/sched_priority description
Date: Tue, 24 Feb 2026 17:15:01 -0800
Message-ID: <20260225012404.358232961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 5a062505aa0ed5f9124c22f07da6ba58950475b2 ]

The .bulk_profile/sched_priority file is always write-only, unlike
the profile/sched_priority files which can be either read-write or
read-only (in case of PF or VFs respectively).

Fixes: 6b514ed2d9a7 ("drm/xe/pf: Add documentation for sriov_admin attributes")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://patch.msgid.link/20251115152659.10853-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-driver-intel-xe-sriov | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-intel-xe-sriov b/Documentation/ABI/testing/sysfs-driver-intel-xe-sriov
index 2fd7e9b7bacc0..7f5ef9eada531 100644
--- a/Documentation/ABI/testing/sysfs-driver-intel-xe-sriov
+++ b/Documentation/ABI/testing/sysfs-driver-intel-xe-sriov
@@ -119,7 +119,7 @@ Description:
 			The GT preemption timeout (PT) in [us] to be applied to all functions.
 			See sriov_admin/{pf,vf<N>}/profile/preempt_timeout_us for more details.
 
-		sched_priority: (RW/RO) string
+		sched_priority: (WO) string
 			The GT scheduling priority to be applied for all functions.
 			See sriov_admin/{pf,vf<N>}/profile/sched_priority for more details.
 
-- 
2.51.0



