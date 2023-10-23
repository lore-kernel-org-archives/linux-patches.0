Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C26914A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VX70Ueo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA84BC433C7;
	Mon, 23 Oct 2023 11:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058940;
	bh=l+IMYyC1MkmroI9cPuIJArJhXCAR8qVY1uNobAHEYkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VX70Ueo5cBHA4hmaueLm6hsoPoFGk6PoHRI7NwGud3FRf7uHrn6C4KybwaZ4UMI1N
	 agi6ahdPU6Z3jiL2bFZ38cx3tnrrPcI2fdLCCt0V9jgPXVgwCdACJK0lUT0wiitXyS
	 iym3OvpfCcdF9pzmqhh/Oiu7ovMtL3mncu0gQeTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dust Li <dust.li@linux.alibaba.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.5 011/241] net/smc: return the right falback reason when prefix checks fail
Date: Mon, 23 Oct 2023 12:53:17 +0200
Message-ID: <20231023104834.143332173@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dust Li <dust.li@linux.alibaba.com>

commit 4abbd2e3c1db671fa1286390f1310aec78386f1d upstream.

In the smc_listen_work(), if smc_listen_prfx_check() failed,
the real reason: SMC_CLC_DECL_DIFFPREFIX was dropped, and
SMC_CLC_DECL_NOSMCDEV was returned.

Althrough this is also kind of SMC_CLC_DECL_NOSMCDEV, but return
the real reason is much friendly for debugging.

Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://lore.kernel.org/r/20231012123729.29307-1-dust.li@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2335,7 +2335,7 @@ static int smc_listen_find_device(struct
 		smc_find_ism_store_rc(rc, ini);
 		return (!rc) ? 0 : ini->rc;
 	}
-	return SMC_CLC_DECL_NOSMCDEV;
+	return prfx_rc;
 }
 
 /* listen worker: finish RDMA setup */


