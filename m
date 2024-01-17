Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875B225A1
	for <patches@lists.linux.dev>; Wed, 17 Jan 2024 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705517708; cv=none; b=YCDEV18vVtBnUStrgX9hkqRIUSr+HPxbO+lkoCCHHLHL+B+mrTr8iw2CUptxHgxEKEDlqF517I6I74eU7DKMo5GmyzmNdo20x7zR13PcglLJ0Wp1+Ge5ZdgsIJJy8RtzdHiJrTvIjPMy3vVblkZ2XShCWUuIO25Q0jLqUGA/qgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705517708; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:From:To:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding; b=bgE41yV76pP3jcpHjgbswN1ajA6cd+9BZ1qkuKO/ZvX7Awcc5mqtwcE1YnI9+895pAHNEJenUUveH1KTy8wEx/FtxGGCR5ydQoXJcTIUknot8oW3z1albOYtyf+Z/s1XF7OMJjBxkTVqvhywXXqOhUkGbFbeCCYuccSYlT/lpcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iGesBH1p; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iGesBH1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705517707; x=1737053707;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=iGesBH1p9y0i7Hrc7KaWs09lzwYWOM1m1PneDeH5Vyapt0Lk9xerkULc
   JBYZgGArGQV0TM/WQyRen8nDR86Rx54UykAj4fAaP0/73pe4HKwWKFyHn
   mz5Z9FDW3ug1QUv8vseH2P69QoXHn6SPRe4C0ZjXrQMn3eMsEQsLScUdg
   JEs+XK5qpDj+8hkWNE4QMqwDW5Z6oUZ4aOcEEBS5wygX9T6Jkn86SPKes
   qpIIqUsNqyW9mHdLGirFxx6GC4e/KxaIaawATSXyGEOZXZGiWQylH44JX
   pRbyyIkkg2XA3n3OlKM0WpGbfbXoOMlKdvznIRifgYU0qMgLHw09i6dpM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="7638045"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="7638045"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 10:55:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="158396"
Received: from viggo.jf.intel.com (HELO ray2.amr.corp.intel.com) ([10.54.77.144])
  by orviesa004.jf.intel.com with ESMTP; 17 Jan 2024 10:55:06 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
To: patches@lists.linux.dev
Subject: [PATCH] x86/fpu: verify xstate buffer size according with requested features
Date: Wed, 17 Jan 2024 10:55:19 -0800
Message-Id: <20240117185519.295436-1-dave.hansen@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


