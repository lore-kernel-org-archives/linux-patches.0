Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BAC18AE1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CDFC433D2;
	Mon, 12 Jun 2023 10:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565712;
	bh=sRuvSVjdUbLYSNb7nubet0wDbUGFIx/qOAgwbh2ZTwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfOH5AywOptUcDYPDijgccKNOUKz5rMUDOwudyh1bufBbbGu9576u7xA9nJ9mJ+M0
	 0y858CMm3zNd5rJbcjxtfv/jvwdlZWwZqwvSWbs6UltgiuX0W2WaizZ/IDHIH85pMM
	 EEu4WzA4+UDIB25gBx8geUzT0/Ti7Hgcm6rSswg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev
Subject: [PATCH 4.14 01/21] i40iw: fix build warning in i40iw_manage_apbvt()
Date: Mon, 12 Jun 2023 12:25:56 +0200
Message-ID: <20230612101651.113244891@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.048240731@linuxfoundation.org>
References: <20230612101651.048240731@linuxfoundation.org>
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

Not upstream as this function is no longer around anymore.

The function i40iw_manage_apbvt() has the wrong prototype match from the
.h file to the .c declaration, so fix it up, otherwise gcc-13 complains
(rightfully) that the type is incorrect.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -414,9 +414,8 @@ void i40iw_manage_arp_cache(struct i40iw
 			    bool ipv4,
 			    u32 action);
 
-int i40iw_manage_apbvt(struct i40iw_device *iwdev,
-		       u16 accel_local_port,
-		       bool add_port);
+enum i40iw_status_code i40iw_manage_apbvt(struct i40iw_device *iwdev,
+					  u16 accel_local_port, bool add_port);
 
 struct i40iw_cqp_request *i40iw_get_cqp_request(struct i40iw_cqp *cqp, bool wait);
 void i40iw_free_cqp_request(struct i40iw_cqp *cqp, struct i40iw_cqp_request *cqp_request);


