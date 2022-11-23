Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7941C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3160C433D6;
	Wed, 23 Nov 2022 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197175;
	bh=tgiFrDg80n7pchFRlTLleiEpeuGunCWBtwQtH9ZZP4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhydL2O3lFsCoZOJONk+ZVD21qMab0WfNPJcMao3w74tthyW4Odh7a7pruYtRE0Cf
	 2LPXCJPTlX5BxJJjDtFhXcy0UpiubFAamOoXEQrWc08zky4c7Sx6N/8wsFfUIo8O7y
	 dY0ECU/gSbuct2EsoQiNoOk4jc03InmVjdTm8Tiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 220/314] drm/amd/display: Fix prefetch calculations for dcn32
Date: Wed, 23 Nov 2022 09:51:05 +0100
Message-Id: <20221123084635.508652842@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dillon Varone <Dillon.Varone@amd.com>

commit 246e667079e8d0fc85f842bceca8c5a3c5da5905 upstream.

[Description]
Prefetch calculation loop was not exiting until utilizing all of vstartup if it
failed once.  Locals need to be reset on each iteration of the loop.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -718,6 +718,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleep
 
 	do {
 		MaxTotalRDBandwidth = 0;
+		DestinationLineTimesForPrefetchLessThan2 = false;
+		VRatioPrefetchMoreThanMax = false;
 #ifdef __DML_VBA_DEBUG__
 		dml_print("DML::%s: Start loop: VStartup = %d\n", __func__, mode_lib->vba.VStartupLines);
 #endif


