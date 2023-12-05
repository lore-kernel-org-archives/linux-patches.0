Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABB06FAF;
	Tue,  5 Dec 2023 03:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWm5k/PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBA0C433C7;
	Tue,  5 Dec 2023 03:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746996;
	bh=VBr1ehc5WlrztukJ6zSDIGE7jTj+zRlLFgy3jWa0so4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWm5k/PG+DZ8yrTkZ9Z64/1Sr1DPIhSBnrZeX1DfP/rxEPbdipzaYk1gjCrL2tU+k
	 ORpep+A9V9hRLlPRlzb5i+5hVWXU6okd9cUxZUY8lBEc5RNK1nwSfNRRO5tD4RKSGu
	 R5tDsGWPta08sYGHJPjWc0T0+uG770E7bPAGyxVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <samson.tam@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 021/107] drm/amd/display: Include udelay when waiting for INBOX0 ACK
Date: Tue,  5 Dec 2023 12:15:56 +0900
Message-ID: <20231205031532.946192352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Lee <alvin.lee2@amd.com>

commit 3c9ea68cb61bd7e5bd312c06a12adada74ff5805 upstream.

When waiting for the ACK for INBOX0 message,
we have to ensure to include the udelay
for proper wait time

Cc: stable@vger.kernel.org # 6.1+
Reviewed-by: Samson Tam <samson.tam@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -964,6 +964,7 @@ enum dmub_status dmub_srv_wait_for_inbox
 		ack = dmub->hw_funcs.read_inbox0_ack_register(dmub);
 		if (ack)
 			return DMUB_STATUS_OK;
+		udelay(1);
 	}
 	return DMUB_STATUS_TIMEOUT;
 }


