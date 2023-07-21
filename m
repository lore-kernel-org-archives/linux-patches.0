Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5064120F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB75CC433C8;
	Fri, 21 Jul 2023 19:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967406;
	bh=0AO8qPHejxEtMIQOlHLwtUJnqomkjLIPe9L54ITXyoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7+vu20s4XsA26UjxhrG3BBT5/7fzrBFVfn9GZ5NQ3HCsByhrFwUZe+KKhm5EgcKe
	 JbfHTFC3s4Lthxx7Yv8XTUYfoZ7DOz2fLtGAbn4FyZbl4R4KRnKhaIl8v/GyQkbTGN
	 /fC8Q7ehrWPm3uULX7boI34XPm3zWtbd6cDvbi+k=
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
Subject: [PATCH 6.1 152/223] drm/amd/display: Correct `DMUB_FW_VERSION` macro
Date: Fri, 21 Jul 2023 18:06:45 +0200
Message-ID: <20230721160527.351931819@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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
@@ -471,7 +471,7 @@ struct dmub_notification {
  * of a firmware to know if feature or functionality is supported or present.
  */
 #define DMUB_FW_VERSION(major, minor, revision) \
-	((((major) & 0xFF) << 24) | (((minor) & 0xFF) << 16) | ((revision) & 0xFFFF))
+	((((major) & 0xFF) << 24) | (((minor) & 0xFF) << 16) | (((revision) & 0xFF) << 8))
 
 /**
  * dmub_srv_create() - creates the DMUB service.


