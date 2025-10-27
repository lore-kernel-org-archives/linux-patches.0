Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE752C15BB;
	Mon, 27 Oct 2025 19:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593146; cv=none; b=mop+jUOOEcYyPJC8/4X16aHp59EBGcq1uIhHx8hNzWS0S+cLaUL/HEZRByPdgx5yUrdxflTUpEekqtms+QSEgC5qDxPuBqL/QJ7ej+g0V+nX3nYt8hZxt6V/S2I/fy8q7+KhAjKt0fFdcaZtDEus6CaFJ42iLRMnXDMpkJlS6uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593146; c=relaxed/simple;
	bh=sxr9ysepk7HQVkTcN0/Y3NPqXEWAf3CrsviekG3SBjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkmhOl3dvcBVP0N4U4EyilotRDYy5cLiou3MrLsKa+DokIBGOnMF0jvimOHBffdhTu/LpNXXHDBXUptsw2G5L7APcx4ceX4MGkm/J/FRvejVP3ifvOsB2H7yrUj8wMx9yPH+TXl1MTH+k732EMmUqxAWCanTmfDb/vWuqP7u4VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPel1tEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPel1tEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72E1C4CEF1;
	Mon, 27 Oct 2025 19:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593146;
	bh=sxr9ysepk7HQVkTcN0/Y3NPqXEWAf3CrsviekG3SBjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPel1tEVWvf5/oiL/icwquS6cq7XY6l5ufYSzQTGoEYkNx8QAcFlDiTjl1HXHKuDk
	 rK/m+Osv3mg3rpstAaVI88I2VqqpeTFyL7JW44SHhX3DKTu+NgKhDdbkzLsIM/B0OZ
	 7ixT5V2kp2oum4546RaauvxYOdv2IJB9H2Z8H/JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 004/184] cgroup/misc: fix misc_res_type kernel-doc warning
Date: Mon, 27 Oct 2025 19:34:46 +0100
Message-ID: <20251027183515.059965797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 0fbbcab7f9082cdc233da5e5e353f69830f11956 ]

Format the kernel-doc for SCALE_HW_CALIB_INVALID correctly to
avoid a kernel-doc warning:

Warning: include/linux/misc_cgroup.h:26 Enum value
 'MISC_CG_RES_TDX' not described in enum 'misc_res_type'

Fixes: 7c035bea9407 ("KVM: TDX: Register TDX host key IDs to cgroup misc controller")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/misc_cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 71cf5bfc6349d..0cb36a3ffc479 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -19,7 +19,7 @@ enum misc_res_type {
 	MISC_CG_RES_SEV_ES,
 #endif
 #ifdef CONFIG_INTEL_TDX_HOST
-	/* Intel TDX HKIDs resource */
+	/** @MISC_CG_RES_TDX: Intel TDX HKIDs resource */
 	MISC_CG_RES_TDX,
 #endif
 	/** @MISC_CG_RES_TYPES: count of enum misc_res_type constants */
-- 
2.51.0



