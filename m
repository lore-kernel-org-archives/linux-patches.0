Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A881392C27;
	Sat, 17 Oct 2026 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255787; cv=none; b=Ubt51wyL1LvDlP+6pdyTvrT0vpZEw8wbvpitU40O6+kqKlHyXxMQXlT/1z0Pd1FqIAzDh2ikZP0EgDG985auH+iPUQ/g23Gm0H0QWTnz1DziJKKBW2giJLeqfXgdYT4l9P3HruZCwErQxkF9Gn/FN+Wi1zEXd4hO1lmcxiLlrns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255787; c=relaxed/simple;
	bh=zcUGvkJveIcO8IT06GPP88WdXIAHCF1n05+WJvM3gCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is7RxGbuK+Nfng3o2SaFPizAvbelOqibU+lYU9uLqDgTmxat29t36XDoIe/ojc+CBxQfIeSEwrTG9hPyGSTgvMTMOvuEf46U4LUpdZQW/MhyAyc/6CDMBBDzd7AVEjqAUFgFHvjskjhy/qxjMCawUhqY69+9OauQz3MW4GsPt5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut428CC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut428CC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A077E1F000C4;
	Sat, 17 Oct 2026 16:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255786;
	bh=HoBn7icPlvlCV7WjxZKSPseHzCbvBWc8CBdRZ75pY70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ut428CC2WbjvIlavpQIEG6ktoPXeQ6iAZpqklEzbEsIACWt+EV2Gof5Ww2b8m9g5b
	 /eT0bhPAy3siXWOdu+lnTx34Mf65lb6c/dw4WfTQTBLE3pW67YX1TC9ktfitW5qGXk
	 XcOkGQaftM7RqpBjtfLLFNu8V85y14gRNj2QBt68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0021/1674] staging: rtl8723bs: fix spacing around operators
Date: Sat, 17 Oct 2026 17:38:13 +0200
Message-ID: <20261017160431.685811493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek BalachandharTN <vivek.balachandhar@gmail.com>

[ Upstream commit 2038fe84b8bdf894b634f777096685e78e8f3774 ]

Fix several instances where operators lacked spaces around them.
This improves readability and brings the driver closer to kernel
coding-style guidelines. No functional change.

Signed-off-by: Vivek BalachandharTN <vivek.balachandhar@gmail.com>
Link: https://patch.msgid.link/20251205021417.2705864-3-vivek.balachandhar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For this stable dependency, retain only the spacing change to the IE
advance in rtw_restruct_wmm_ie(). This supplies the exact context needed
by target commit 28a289beaf226 ("staging: rtl8723bs: fix OOB read in
rtw_restruct_wmm_ie()"). Drop the unrelated operator-spacing hunks.

Keep the existing bounds-first WMM match condition from stable commit
4dd2d9cf563c5 (upstream a75281626fc8f); applying the older condition
would undo its out-of-bounds-read fix. No functional change.

Stable-dep-of: 28a289beaf22 ("staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 1d44f6a3db183..97618a3636994 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2015,7 +2015,7 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 			break;
 		}
 
-		i += (in_ie[i+1]+2); /*  to the next IE element */
+		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
 	return ielength;
-- 
2.53.0



