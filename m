Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1151DCB09;
	Tue, 22 Jul 2025 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193068; cv=none; b=QDhLONralhWOooajKHQHjKRYHstSnXELPas+Q4FfZcZL7wUyZyH57jjVzk/Ofx5iDYO8UI9kohRKFcJh6XYAcsTTUFbYuRtRMlkP55DB1JyMNi66VDEfIJwbaKicGSQ5w6ZMy0IlMKAvzjqPuq4vnOLr3YKxkAlyXrxqMRdIKQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193068; c=relaxed/simple;
	bh=V1IrBlllvgk+JnRgCI+kttnXmMLnog9eU62j+7CgkLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCXZtmWvkN59wQJsyOpAd4wVPVyeeJIco94IF/EPXzR1SErTpOAkSjbf8OGdBqpoBNcydTkovNQobkKJubUzsQiWFO1QkhXNrcrHF+qeWfa2JHOaH9NJSptD8MVtR6JYimpDSyIOrmFv3o46XAxG9hNdpLw2Vau/XXqz8QaPuOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT6+gimw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT6+gimw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FB5C4CEEB;
	Tue, 22 Jul 2025 14:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193068;
	bh=V1IrBlllvgk+JnRgCI+kttnXmMLnog9eU62j+7CgkLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HT6+gimw5sIhhWpmogX4y2/tAX4NUjmz20e8+xEPgJw+uIYipO6mgtb3bc2tcVMgd
	 uoqfbP85VENvqGkQTYJs5vRjrBu30iSQsBoweykOUJf5vj3AJrLHzRsy4mapuRWInH
	 BgOWyBzS7zuAhQ3+75HZwWssqYEdyHBPkI+aZcAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 108/158] ice: check correct pointer in fwlog debugfs
Date: Tue, 22 Jul 2025 15:44:52 +0200
Message-ID: <20250722134344.774961163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit bedd0330a19b3a4448e67941732153ce04d3fb9b ]

pf->ice_debugfs_pf_fwlog should be checked for an error here.

Fixes: 96a9a9341cda ("ice: configure FW logging")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_debugfs.c b/drivers/net/ethernet/intel/ice/ice_debugfs.c
index 9fc0fd95a13d8..cb71eca6a85bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_debugfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_debugfs.c
@@ -606,7 +606,7 @@ void ice_debugfs_fwlog_init(struct ice_pf *pf)
 
 	pf->ice_debugfs_pf_fwlog = debugfs_create_dir("fwlog",
 						      pf->ice_debugfs_pf);
-	if (IS_ERR(pf->ice_debugfs_pf))
+	if (IS_ERR(pf->ice_debugfs_pf_fwlog))
 		goto err_create_module_files;
 
 	fw_modules_dir = debugfs_create_dir("modules",
-- 
2.39.5



