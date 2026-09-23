Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F8F53162E;
	Wed, 23 Sep 2026 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174094; cv=none; b=L5bgAqPR3i3ml+TgGK2hdQBDFBBMX9XZjhW+OKgIWZzBQuxliSfHtJfM3s3yGy0o/eKMHuIJki8TC6i+mYFp7eZZy5lJNxfFHD6qFrOxb7aPAdnLYNNLuHWusRk9CRrYqP+FMeBnMZqGxYGCteeVm0Zm+1C+dtntqYkJajvYimM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174094; c=relaxed/simple;
	bh=JhF4/T++q0xUiNYOtC4rq49FZrhCxjKYnVtWamA+EfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCtFppjOUyhszZx1cNvEjqcbo4UsZsMjI3Xe1DJ5SuRydrG0FvqVHFKByM8LXHTd7W3yNQ9m+y0aEz9q5LhqlIuYIBe6r/2EThMJ+ApCu6WyiteExE8svtx/4DUoWN55/Kw6kKPtRqhCQv7T+wvU5k9UgMM3DLtIiXav01E65s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hx1Wh77Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hx1Wh77Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579631F00893;
	Wed, 23 Sep 2026 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174092;
	bh=fr644Xh8s/4SNRzMZ2Yr751GgMWM18J1U2gk3f+LDbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hx1Wh77ZLNnB+VXScWiRl7ymnVK7M10Wgi8zq+vTfvzUo7IwTXWUF1kcnvP5sY6oC
	 mVKtPHQLNDLFW/udipoQq/+o8ZWrRTB9QmK2KZcA5PQUCZIYZe1Bpx5IUY7SAoT0qN
	 8yi1pReiX5Z//+jhMq4qRTaJFZBbBnVYYKg1Z1/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Arulprabhu Ponnusamy <arulponn@cisco.com>,
	Gian Carlo Boffa <gcboffa@cisco.com>,
	Arun Easi <aeasi@cisco.com>,
	Hannes Reinecke <hare@kernel.org>,
	Lee Duncan <lduncan@suse.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 431/438] scsi: fnic: Bump up version number
Date: Wed, 23 Sep 2026 16:07:32 +0200
Message-ID: <20260923140656.098905270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karan Tilak Kumar <kartilak@cisco.com>

[ Upstream commit 2265541d221dc550dc89b52e49e9d9eb2f824996 ]

Bump up version number to 1.9.0.0.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260724174811.5118-14-kartilak@cisco.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 0cb1fd924126 ("scsi: fnic: Fix missed link-up when critical IRQ targets offline CPU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fnic/fnic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.3"
+#define DRV_VERSION		"1.9.0.0"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 


