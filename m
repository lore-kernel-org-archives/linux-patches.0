Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1A52E5B04;
	Tue,  8 Jul 2025 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994228; cv=none; b=FRVauWOw70UcbLbELXtaVjqTWtSQpTUHuL44QbfXE2HkXqSnR7p/e18Dp3eIhSrZ1xVJqpqVyqgoY/MFXUxbIrhRMJ8DG5Nu8x874UgBkyuwLJKcG9T9gvpYAE7ks7mNREGJi6mfzOWiJ8fr3dE808zWlWWKU2MOZC9dH+5Ie+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994228; c=relaxed/simple;
	bh=eOCd0SgkDWiP0j2dKlfYcAYHph9eJJQ1NQAhFvNL+38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3JKimEh1UNkSKZHEtQvQtGEc/QXhhHUYkGQgRK6ef7PoGUnMihMuOhmbTG3R+jXo+vP8Nz9NA5cWp21LxAG6Oj1lgO15mM0FzCrtEXpdg/p+xwcSLK68+h07rgHUliElOdzI0IOq1cIrWsppoSsheapFQGkL3xzPHkGJO0gv9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOmQxfO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOmQxfO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31998C4CEF6;
	Tue,  8 Jul 2025 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994228;
	bh=eOCd0SgkDWiP0j2dKlfYcAYHph9eJJQ1NQAhFvNL+38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOmQxfO2knQjpx9LLkMQ/e2bT2oi1P2WS4YceiRIX0WUdAbamrBe1jqBz761EkQs6
	 qOOrb98v0M+u7LEDYJAUnQ1fF163kZM3rVmyJRIcPPGcl3+TTEOs2pLDFhPzg7gbMe
	 VgBZHMeu8NZREpslwS7kDCORHeMOvXELs8i70F/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+92c6dd14aaa230be6855@syzkaller.appspotmail.com,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/160] wifi: ath6kl: remove WARN on bad firmware input
Date: Tue,  8 Jul 2025 18:22:50 +0200
Message-ID: <20250708162235.081415349@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e7417421d89358da071fd2930f91e67c7128fbff ]

If the firmware gives bad input, that's nothing to do with
the driver's stack at this point etc., so the WARN_ON()
doesn't add any value. Additionally, this is one of the
top syzbot reports now. Just print a message, and as an
added bonus, print the sizes too.

Reported-by: syzbot+92c6dd14aaa230be6855@syzkaller.appspotmail.com
Tested-by: syzbot+92c6dd14aaa230be6855@syzkaller.appspotmail.com
Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Link: https://patch.msgid.link/20250617114529.031a677a348e.I58bf1eb4ac16a82c546725ff010f3f0d2b0cca49@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/bmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index af98e871199d3..5a9e93fd1ef42 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -87,7 +87,9 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 		 * We need to do some backwards compatibility to make this work.
 		 */
 		if (le32_to_cpu(targ_info->byte_count) != sizeof(*targ_info)) {
-			WARN_ON(1);
+			ath6kl_err("mismatched byte count %d vs. expected %zd\n",
+				   le32_to_cpu(targ_info->byte_count),
+				   sizeof(*targ_info));
 			return -EINVAL;
 		}
 
-- 
2.39.5



