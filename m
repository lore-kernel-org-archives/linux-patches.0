Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EC51ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B868C433C9;
	Tue, 25 Jul 2023 11:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284668;
	bh=D7NfNtNZ9Pfq2FlxyxLf/mPul4oJm8I2p6vezz0xz4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTE0JP0tLzN2wKX8telAOdW6Zj2jGCAcR1KFdP+BcjCmJhX7gzVnD9SkUmzcVAlqR
	 guCTUIA5kgfZ8JjoJeh6e7Np0S8P5QBsEwW27UPvEHWjco6M9B5OEOZ3+t8rmBPZ45
	 hNVCOfVtRExCptT48J2BPiJ0xLtrHWcUTyEDvaTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.ns.wang@amd.com>,
	Marc Rossi <Marc.Rossi@amd.com>,
	Hamza Mahfooz <Hamza.Mahfooz@amd.com>,
	"Tsung-hua (Ryan) Lin" <Tsung-hua.Lin@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 410/509] drm/amd/display: Correct `DMUB_FW_VERSION` macro
Date: Tue, 25 Jul 2023 12:45:49 +0200
Message-ID: <20230725104612.481996296@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 274d205cb59f43815542e04b42a9e6d0b9b95eff upstream.

The `DMUB_FW_VERSION` macro has a mistake in that the revision field
is off by one byte. The last byte is typically used for other purposes
and not a revision.

Cc: stable@vger.kernel.org
Cc: Sean Wang <sean.ns.wang@amd.com>
Cc: Marc Rossi <Marc.Rossi@amd.com>
Cc: Hamza Mahfooz <Hamza.Mahfooz@amd.com>
Cc: Tsung-hua (Ryan) Lin <Tsung-hua.Lin@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dmub/dmub_srv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
+++ b/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
@@ -347,7 +347,7 @@ struct dmub_srv {
  * of a firmware to know if feature or functionality is supported or present.
  */
 #define DMUB_FW_VERSION(major, minor, revision) \
-	((((major) & 0xFF) << 24) | (((minor) & 0xFF) << 16) | ((revision) & 0xFFFF))
+	((((major) & 0xFF) << 24) | (((minor) & 0xFF) << 16) | (((revision) & 0xFF) << 8))
 
 /**
  * dmub_srv_create() - creates the DMUB service.


