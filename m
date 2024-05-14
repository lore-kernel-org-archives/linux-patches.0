Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE134139CE4;
	Tue, 14 May 2024 10:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683016; cv=none; b=B+coOdaxFrYKhta8zcYYQ7/Sfu3MPh7/tC27h92DacLwaPwfmqO46if0IhlxOv/a91CVA/cN9D/SNZowbaxgzHQnaui1eog30an+uLONjo8vlwcrKs7V7IyVOgXalt4c6h/8cX80AdUvYpW04QZYOPeYPRTkEliuRfeU65X+mjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683016; c=relaxed/simple;
	bh=1dQCvDBaHOeb7LKXfEhlk5UUG4go6azYSckIR9z4oVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVhBgFRVLWlHygyLQqExM4JBEK0mMkWY8vtNamFNSrUtxYehvnPLD8ixNOMfxNhIuSq8orlHC13aW29uQXzbC8G8fRJTSVHNHEI29GV+zcKt6zrF853hnqWmQtcePdNIJUidxB+9pmcToZ46C1bfBQTmGsuMP6jYeFegqyFAJuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udGEz0Qo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udGEz0Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3700C2BD10;
	Tue, 14 May 2024 10:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683016;
	bh=1dQCvDBaHOeb7LKXfEhlk5UUG4go6azYSckIR9z4oVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udGEz0Qo6NVPBp67CBnggxHjKQ2KOOOpR7A09GGnHe6DmpVOGo+/9E7WhwMVyF+Br
	 gmGDYWJqHM30hFSpqgAqQV9mtStSUmM5SOcBAckDwWb4ODtuV99ImswIYVFf63a8WQ
	 7YruABFLWxiFzcEny3Dm89iPi8LfU82IW3vGzq0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 152/336] accel/ivpu: Fix missed error message after VPU rename
Date: Tue, 14 May 2024 12:15:56 +0200
Message-ID: <20240514101044.340992708@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit 0d298e23292b7a5b58c5589fe33b96e95363214f ]

Change "VPU" to "NPU" in ivpu_suspend() so it matches all other error
messages.

Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402104929.941186-8-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_pm.c b/drivers/accel/ivpu/ivpu_pm.c
index 2d706cb29a5a5..64618fc2cec40 100644
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -62,7 +62,7 @@ static int ivpu_suspend(struct ivpu_device *vdev)
 
 	ret = ivpu_shutdown(vdev);
 	if (ret)
-		ivpu_err(vdev, "Failed to shutdown VPU: %d\n", ret);
+		ivpu_err(vdev, "Failed to shutdown NPU: %d\n", ret);
 
 	return ret;
 }
-- 
2.43.0



