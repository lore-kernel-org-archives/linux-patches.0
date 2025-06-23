Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8093C1F7580;
	Mon, 23 Jun 2025 22:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716522; cv=none; b=se1QNquaqaCFEUqAUy2N95P8FGo4MIe3VjcjN86uXV0MipRLT27H1qyJQ+zWM6DFtIzrzaZvZHNEkalNV/Y/ARVaz92G4W9zgb0QZK5Rq1fkV6FGa5oE20LrecLLL5nx+LE4TmRLcw89HGOyRp/kWQyXi7K6acgwk3iiIXhKw2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716522; c=relaxed/simple;
	bh=JxkJbgfRq82Ov6LSvQxmMlQB1HrF0ihMvmbHkWhW2sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/zw20Rz4eW7srXE7EbL0ri2/rZq8I+hMMnbPjA0cS2RojOgqzpi77EifhwhJX34cngdXP7pQ/wyH6FRPMAeyXAjTspcnAM91eKDuP7hGrqHmORXHDp2F4KZt5QWFd9mr1p4gBQs86Qg1Yn0LyPQSmbsXzkUpWHkRUEnZ00ruWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqN8TRKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqN8TRKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193D7C4CEEA;
	Mon, 23 Jun 2025 22:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716522;
	bh=JxkJbgfRq82Ov6LSvQxmMlQB1HrF0ihMvmbHkWhW2sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqN8TRKb6nxxW7IGWaUjlN4l9Yl+xzADzwCNgWCHw36XBekFk5auER04nmlKL4Vyo
	 c6+dvSmaiTMTXNCsA+lQ2tzUju5m00CG7s/Mvbf1QJT2XRF3reFk2qYVHu5iPWQHxR
	 IzVWw1ba6mYq83djg/jaEVTm+89mTE555CCCsrFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	reox <mailinglist@reox.at>,
	Avadhut Naik <avadhut.naik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.15 558/592] EDAC/amd64: Correct number of UMCs for family 19h models 70h-7fh
Date: Mon, 23 Jun 2025 15:08:36 +0200
Message-ID: <20250623130713.715703433@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avadhut Naik <avadhut.naik@amd.com>

commit b2e673ae53ef4b943f68585207a5f21cfc9a0714 upstream.

AMD's Family 19h-based Models 70h-7fh support 4 unified memory controllers
(UMC) per processor die.

The amd64_edac driver, however, assumes only 2 UMCs are supported since
max_mcs variable for the models has not been explicitly set to 4. The same
results in incomplete or incorrect memory information being logged to dmesg by
the module during initialization in some instances.

Fixes: 6c79e42169fe ("EDAC/amd64: Add support for ECC on family 19h model 60h-7Fh")
Closes: https://lore.kernel.org/all/27dc093f-ce27-4c71-9e81-786150a040b6@reox.at/
Reported-by: reox <mailinglist@reox.at>
Signed-off-by: Avadhut Naik <avadhut.naik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org
Link: https://lore.kernel.org/20250613005233.2330627-1-avadhut.naik@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/amd64_edac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3879,6 +3879,7 @@ static int per_family_init(struct amd64_
 			break;
 		case 0x70 ... 0x7f:
 			pvt->ctl_name			= "F19h_M70h";
+			pvt->max_mcs			= 4;
 			pvt->flags.zn_regs_v2		= 1;
 			break;
 		case 0x90 ... 0x9f:


