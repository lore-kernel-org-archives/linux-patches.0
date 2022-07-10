Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3F31C17
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 18:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657477527; x=1689013527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6aFXrMG+va2IZjOmp0OkSsM4/LOorOUIHVe5fbwzo7g=;
  b=mCsYYxcO1hn7v7HCyWhVGjf5UWhMqKkhORs6aDTZFFaJRI5Mjn30Ul05
   vMeyZdKoI/z7Ke9R55AW6tAK6QXRRUjJj/GaTvwgijS75m8zTiN6+1cpN
   GOLBXmVrKnNMVkOTsmXGg7P1Axf5YjSlfe56Fb14SVlRTR+WU9dePDgcN
   yMtyyieMzvlQgHELaqq2f5WdXXw8/3tVWAo2e816Mty/C3zJvzBUuf77F
   OE6ggxk9Co0QqbklgmTarPEquJjy9MhieQZ8Ld+PmWTx6oJfYoCObThj3
   i0srmpzPviTBCcEdnw8+Z09PPgvT9hviznA1bS8ops9Rx/miOUAWLG+zF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267572505"
X-IronPort-AV: E=Sophos;i="5.92,261,1650956400"; 
   d="scan'208";a="267572505"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 11:25:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,261,1650956400"; 
   d="scan'208";a="736864827"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 11:25:25 -0700
From: Tony Luck <tony.luck@intel.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	markgross@kernel.org,
	ashok.raj@intel.com,
	ravi.v.shankar@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 0/2] Two fixes for IFS
Date: Sun, 10 Jul 2022 11:25:19 -0700
Message-Id: <20220710182521.60642-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <c416b93b-8adc-d9a8-ef0d-594cce6d9a9d@redhat.com>
References: <c416b93b-8adc-d9a8-ef0d-594cce6d9a9d@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hans ... if you are pushing to Linus to add "BROKEN", then could
you include these two patches to make it fractionally less broken?

-Tony

Jithu Joseph (2):
  Documentation: Correct IFS reload documentation
  platform/x86/intel/ifs: return error on load failure

 drivers/platform/x86/intel/ifs/ifs.h  | 2 +-
 drivers/platform/x86/intel/ifs/load.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.35.3

