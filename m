Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC08833CFD;
	Fri, 24 Nov 2023 18:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3r3yTFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F16C433C8;
	Fri, 24 Nov 2023 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851048;
	bh=IzfGj6hDAhojaJbzBpTtdhb4WyYv87oa8ZQGJ/X+dgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3r3yTFz953lHgsmaq1QEpuiWIhM8QNqHBj0Iumo7VMZUXv4CdFS+a9Ss4m4xev0B
	 a+497MP+xD2W8avFjA4nZjziwo+/S8lTxNPA0CsLYYDUbqYFV0S8CJhvarEQdLxMnS
	 D9LqErucUE/yqpobueed3tqvwDjGJKNJU0iX4KbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.5 292/491] powercap: intel_rapl: Downgrade BIOS locked limits pr_warn() to pr_debug()
Date: Fri, 24 Nov 2023 17:48:48 +0000
Message-ID: <20231124172033.347969361@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit a60ec4485f1c72dfece365cf95e6de82bdd74300 upstream.

Before the refactoring the pr_warn() only triggered when
someone explicitly tried to write to a BIOS locked limit.
After the refactoring the warning is also triggering during
system resume. The user can't do anything about this so
printing scary warnings doesn't make sense

Keep the printk but make it pr_debug() instead of pr_warn()
to make it clear it's not a serious issue.

Fixes: 9050a9cd5e4c ("powercap: intel_rapl: Cleanup Power Limits support")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 40a2cc649c79..2feed036c1cd 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -892,7 +892,7 @@ static int rapl_write_pl_data(struct rapl_domain *rd, int pl,
 		return -EINVAL;
 
 	if (rd->rpl[pl].locked) {
-		pr_warn("%s:%s:%s locked by BIOS\n", rd->rp->name, rd->name, pl_names[pl]);
+		pr_debug("%s:%s:%s locked by BIOS\n", rd->rp->name, rd->name, pl_names[pl]);
 		return -EACCES;
 	}
 
-- 
2.43.0



