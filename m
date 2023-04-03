Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDF36FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55508C433EF;
	Mon,  3 Apr 2023 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532481;
	bh=QNjg35JqVGRkiXWOhfrxOD6oYTzm8nvTMwy5KmuZDYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckpC3lh+Lz30qBnjqm1Zc7ba9AzVO+AbyHuiby+nREMe7lrwCNBoy/5EkQ3ffTubK
	 vCSspNp/3lcP2NyDIhasTkmxzHxcoJRMlTSAHHiaWtom4nzwoGeEwsidv3wkvj37rN
	 EG5lCYuIj0ovxmUY3VyB5V4+gjMTL/cymP+j7ivU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 99/99] x86/PVH: avoid 32-bit build warning when obtaining VGA console info
Date: Mon,  3 Apr 2023 16:10:02 +0200
Message-Id: <20230403140407.023606727@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Beulich <jbeulich@suse.com>

commit aadbd07ff8a75ed342388846da78dfaddb8b106a upstream.

In the commit referenced below I failed to pay attention to this code
also being buildable as 32-bit. Adjust the type of "ret" - there's no
real need for it to be wider than 32 bits.

Fixes: 934ef33ee75c ("x86/PVH: obtain VGA console info in Dom0")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Link: https://lore.kernel.org/r/2d2193ff-670b-0a27-e12d-2c5c4c121c79@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/enlighten_pvh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -48,7 +48,7 @@ void __init xen_pvh_init(struct boot_par
 		struct xen_platform_op op = {
 			.cmd = XENPF_get_dom0_console,
 		};
-		long ret = HYPERVISOR_platform_op(&op);
+		int ret = HYPERVISOR_platform_op(&op);
 
 		if (ret > 0)
 			xen_init_vga(&op.u.dom0_console,


