Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2738E168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C306C4339C;
	Mon,  8 May 2023 10:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542550;
	bh=WsR8fgP0yl+3Z6wf2pmqPsUwLcGJv9euAvjGdsRm/No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3qJ49GIETspPXq+2oDolWgM0UxQNrYyxPq0MTAO6/9xHkReJq9KFYiGY2lzA8dXj
	 fOOxqrQrVDcAZLi+/R9B+aIhuv7qRCaYsHexlCCxTNcEwn+CPGCeQnGQuzC2WOF87Y
	 h/Jyl8oqDbC+VDtIu/8PitZXo1s4VikeHBF96rHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 471/663] HID: amd_sfh: Correct the structure fields
Date: Mon,  8 May 2023 11:44:57 +0200
Message-Id: <20230508094443.509830335@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 7e7fdab79899f62de39c9280fb78f3d3b02ac207 ]

Misinterpreted sfh_cmd_base structure member fields. Therefore, adjust
the structure member fields accordingly to reflect functionality.

Fixes: 93ce5e0231d7 ("HID: amd_sfh: Implement SFH1.1 functionality")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h
index ae47a369dc05a..a3e0ec289e3f9 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.h
@@ -33,9 +33,9 @@ struct sfh_cmd_base {
 		struct {
 			u32 sensor_id		: 4;
 			u32 cmd_id		: 4;
-			u32 sub_cmd_id		: 6;
-			u32 length		: 12;
-			u32 rsvd		: 5;
+			u32 sub_cmd_id		: 8;
+			u32 sub_cmd_value	: 12;
+			u32 rsvd		: 3;
 			u32 intr_disable	: 1;
 		} cmd;
 	};
-- 
2.39.2



