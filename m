Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC54F17730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41441C433D2;
	Mon, 15 May 2023 18:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173995;
	bh=2z0p8WY8f22KF0zur3OdAoOOhfM6vd530y5pF3u+5Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0tw35CsmgAGhtx+JLLrWy8nyuYR9JbvluBeV/5IF+yA3d44Hd7uxslrnnMJ5k6qj
	 oSVVlrsQGyStdNAU+eUZrDYPCdNxd3LYHik2Mg/CtyT5WTAdnNi50iRgavJOvOz4Hv
	 UGelxGuz8L8phbPgn3I3AoGf+zE+ufeAn0q0yTJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 274/282] PM: domains: Restore comment indentation for generic_pm_domain.child_links
Date: Mon, 15 May 2023 18:30:52 +0200
Message-Id: <20230515161730.586930205@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit afb0367a80553e795e7ad055299096544454f3f6 upstream.

The rename of generic_pm_domain.slave_links to
generic_pm_domain.child_links accidentally dropped the TAB to align the
member's comment.  Re-add the lost TAB to restore indentation.

Fixes: 8d87ae48ced2dffd ("PM: domains: Fix up terminology with parent/child")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
[ rjw: Minor subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pm_domain.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -96,7 +96,7 @@ struct generic_pm_domain {
 	struct dev_pm_domain domain;	/* PM domain operations */
 	struct list_head gpd_list_node;	/* Node in the global PM domains list */
 	struct list_head parent_links;	/* Links with PM domain as a parent */
-	struct list_head child_links;/* Links with PM domain as a child */
+	struct list_head child_links;	/* Links with PM domain as a child */
 	struct list_head dev_list;	/* List of devices */
 	struct dev_power_governor *gov;
 	struct work_struct power_off_work;


