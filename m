Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B24115C90
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861689; x=1699397689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zb6DFxJeoRkypDZP83pg8o1HUltF1td45iw5cJt0xA4=;
  b=Ohmdz7+TYuS2YlPKYqiWbb4+p4yZpwHniVtNNPBfXNipahAUpzzxiNsk
   VtZbVxvcaw6zAvbPfwNgWGnLFxre5RasFdYEq/O1+lgdpbTQbOQUD2XsR
   faQP2owFxXJkdc+dqVEpIW5spXv9yq0/B3r8zYYRFpGKF95MTJh4j8IP8
   FX+0IfIj4n1tk9ly7/FzDo6ThQriJ3KV45+2BuNiHugxdNh4q6iPu+cyM
   bGPcQYlTSRJuJuGiVIA2Vgv2arbwfCmTe/Bk7moi8L7CF67Spb0GGZhGE
   LLL9rH1MrNW7lmPMux9SpPqKKm8+/9EeIPkM1usVWmzzaiqNizSUMeHzE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697402"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697402"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811012970"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811012970"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:46 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH v2 05/14] x86/microcode/intel: Use appropriate type in microcode_sanity_check()
Date: Mon,  7 Nov 2022 14:53:14 -0800
Message-Id: <20221107225323.2733518-6-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107225323.2733518-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The data type of print_err parameter used by microcode_sanity_check()
is int. In prepration for exporting this function, to be used by
the IFS driver, Convert it to a more appropriate bool type for readability.

No functional change intended.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 arch/x86/kernel/cpu/microcode/intel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 4e611a708718..234b163806ea 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -135,7 +135,7 @@ static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigne
 		intel_ucode_patch = p->data;
 }
 
-static int microcode_sanity_check(void *mc, int print_err)
+static int microcode_sanity_check(void *mc, bool print_err)
 {
 	unsigned long total_size, data_size, ext_table_size;
 	struct microcode_header_intel *mc_header = mc;
@@ -253,7 +253,7 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 		mc_size = get_totalsize(mc_header);
 		if (!mc_size ||
 		    mc_size > size ||
-		    microcode_sanity_check(data, 0) < 0)
+		    microcode_sanity_check(data, false) < 0)
 			break;
 
 		size -= mc_size;
@@ -792,7 +792,7 @@ static enum ucode_state generic_load_microcode(int cpu, struct iov_iter *iter)
 		memcpy(mc, &mc_header, sizeof(mc_header));
 		data = mc + sizeof(mc_header);
 		if (!copy_from_iter_full(data, data_size, iter) ||
-		    microcode_sanity_check(mc, 1) < 0) {
+		    microcode_sanity_check(mc, true) < 0) {
 			break;
 		}
 
-- 
2.25.1

