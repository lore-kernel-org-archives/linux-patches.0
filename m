Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBA923DE8B
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733825647; cv=none; b=mst+mw4wgm34JygWPRZxvQdL1PKXvJXPUU0ZROF4kxL8Z+Ofk5HusN8wfNc6xGyoHgxn4aYWw6nOJnHm/RXPkqEZgxpN0IR3eRkYZ002fScSHTlIjhJAJozPkw94FtQR9HTwQ/NCW5y1x0UN7atZ3kbcLgAt+pk41YXMwsyrw5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733825647; c=relaxed/simple;
	bh=lujt3h3CG05++c6e+i+W692dngHXG+tuybMjifRcWR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPf9PhUk+Fz1X3yJGlNXOUeapGc6LjnN7yCzASuzVCqHtT6yfpHf7AtJevqi8a6Socl57JUE426L5gVn0GJpXsxnN5gcTuyOSsHvC/Sq/4ITcS5YVRSj/0zexZUT8wA7BW6pjArGxZ7O8GN1vQh3EmOrngm35l+zGBJ6u588TH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=TKGdfG99; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="TKGdfG99"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EF33640E02B9;
	Tue, 10 Dec 2024 10:14:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Sowt0oMZdali; Tue, 10 Dec 2024 10:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733825639; bh=yrGa7tpyKCRTPnqr9DVCHERHwkS6nI41a3G5vTxiZOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TKGdfG99NQvFzj1PHJgtpk5QguaEOoOqzYZ+H7oUmDkZikMh28uI5CPlmBiqUohXS
	 Ilzb14h0rxoxxjUbob34sNJ/4ZFVjnM9sDmoFdApmFQMvZqviITcs0A7FclutCiJmB
	 vilryZ4AeWg7SK5V3mYGmgJoeC9wjtuPWrVUBEVdeefeZ78GFUBsHt7/PnS42idIvP
	 A2Mww5ncWMq+vRThsnFbCFsRNqqbC7L3miqri5a7cRhE6SSBC2+UU3gOYynpQ/izpg
	 FIKqKJNv9jrwZ5fM44ovGE4av8t5ZfhA1pj23GNukXlVTAVhveLW10QUsh08DMCLbl
	 NmaOnJQhkQIZ/geAlGu3mnVLZdEcMagg8vx2uabE498hIaQMcjfUekDMqKUhG3QYOA
	 0jR7QW4r3VeZSo8WWnX2Mf80BA97TPlIzZZ9zzvpFlVTh0b2JZuCt98dLj0z2chBeK
	 yh1+cFHZYECg15fH4fCrwszq8yBCy+8wE8fmpZ/uHwJ5I7ELsrLwXGHSZmiV9JYaQC
	 aS3M9OiE7x9lCdHVcfChKVVtLry8GwH47LJgC+DwDeCfP5sB/mJoH7eK44wmLx7rE0
	 wmzFPvPEzgiW564DNxSIAiszWWG6pBM/Ti9DgGw1NiihSByksUUJsDsm0hddt7wUgg
	 pVQnj2RsDd8ECv/LAHE3ZG98=
Received: from zn.tnic (p200300ea971f9307329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9307:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EC24040E0286;
	Tue, 10 Dec 2024 10:13:44 +0000 (UTC)
Date: Tue, 10 Dec 2024 11:13:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v11 2/8] x86/resctrl: Prepare for per-CTRL_MON group
 mba_MBps control
Message-ID: <20241210101339.GBZ1gUU3LiI7wAS3vQ@fat_crate.local>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <20241206163148.83828-3-tony.luck@intel.com>
 <20241209204519.GAZ1dW3-NjcL4Sewaf@fat_crate.local>
 <SJ1PR11MB6083BA367F2CDFC92D87FDA1FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20241209222047.GKZ1dtPxIu5_Hxs1fp@fat_crate.local>
 <SJ1PR11MB60830B8ED36CCA7E304D9E97FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <678cef69-78ef-4951-bd31-10abe646e6d8@intel.com>
 <Z1eEti6Kswtb3HC5@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z1eEti6Kswtb3HC5@agluck-desk3>

On Mon, Dec 09, 2024 at 04:00:54PM -0800, Luck, Tony wrote:
> Reinette is right. The post-split home of this is not <linux/resctrl.h>
> but fs/resctrl/internal.h which doesn't exist yet.
> 
> So Boris is right, this declaration should be added to arch/x86/kernel/cpu/resctrl/internal.h
> by this patch to be moved later.

Done:

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 485800055a7d..542d01c055aa 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -510,6 +510,7 @@ extern struct mutex rdtgroup_mutex;
 extern struct rdt_hw_resource rdt_resources_all[];
 extern struct rdtgroup rdtgroup_default;
 extern struct dentry *debugfs_resctrl;
+extern enum resctrl_event_id mba_mbps_default_event;
 
 enum resctrl_res_level {
 	RDT_RESOURCE_L3,
@@ -653,5 +654,4 @@ void resctrl_file_fflags_init(const char *config, unsigned long fflags);
 void rdt_staged_configs_clear(void);
 bool closid_allocated(unsigned int closid);
 int resctrl_find_cleanest_closid(void);
-
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index fd05b937e2f4..d94abba1c716 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -49,8 +49,6 @@ enum resctrl_event_id {
 	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
 };
 
-extern enum resctrl_event_id mba_mbps_default_event;
-
 /**
  * struct resctrl_staged_config - parsed configuration to be applied
  * @new_ctrl:		new ctrl value to be loaded

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
