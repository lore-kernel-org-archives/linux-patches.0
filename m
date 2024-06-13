Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42231465A7;
	Thu, 13 Jun 2024 12:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281292; cv=none; b=IhUWljc42ua0/xVrRMW1zmT34nQvpk9yhhdiaj/wMO9q3lBU/bu13aRfSdWT1A4V8yxU7fkK6npji8ZGGq7oEnIPZC2uVBH3SFWznNwAz0sBai+bG2GZj/Bh9J29EPVBCngzRae45SN02/vM0KNwOmoAfdqeX9/JQcs6d4cWwWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281292; c=relaxed/simple;
	bh=8CCw4wuwBPORvh9ZLQbmuKtceb8lIV4ZsXX/oc5KOOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdxJBziY1PFQg2chFFSsMh/GmKWtv2TO2GC2UhGj2sd+cuoVxemG2hXfreqUr99Iz4TpkDQ0lR1PYFjBb61IIEeOMlijatnulOiuhLOih2ofixWJ95KJdOSOhrnCnA6V4vnYD3yHKeM7b16KNE1ttdtX8q/PPMeL9PTvuE7fHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWTlg1tN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWTlg1tN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A5EC2BBFC;
	Thu, 13 Jun 2024 12:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281292;
	bh=8CCw4wuwBPORvh9ZLQbmuKtceb8lIV4ZsXX/oc5KOOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWTlg1tNxRuNdsZICV8DyUaUPr2V7YkFIICMPE8TfkRbD9wzHErYpNSiGMEbpZyd7
	 Qjq4sbdBNrXO8CiasojzYKneTxhd5TxriQwfk9oXDQEEj34OkQh7d2DYjnejB6J3WX
	 aEf/cNqFVaxNDcWEKQUXv4kn7Pzf+SbOt/an79rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/317] um: vector: fix bpfflash parameter evaluation
Date: Thu, 13 Jun 2024 13:33:44 +0200
Message-ID: <20240613113255.523213500@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 584ed2f76ff5fe360d87a04d17b6520c7999e06b ]

With W=1 the build complains about a pointer compared to
zero, clearly the result should've been compared.

Fixes: 9807019a62dc ("um: Loadable BPF "Firmware" for vector drivers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/vector_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index fc662f7cc2afb..c10432ef2d410 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -142,7 +142,7 @@ static bool get_bpf_flash(struct arglist *def)
 
 	if (allow != NULL) {
 		if (kstrtoul(allow, 10, &result) == 0)
-			return (allow > 0);
+			return result > 0;
 	}
 	return false;
 }
-- 
2.43.0



