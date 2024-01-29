Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0688F1586DC;
	Mon, 29 Jan 2024 17:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548240; cv=none; b=AusttmnITLatQdD5bmVZVA+gAqHsZrz0V35zF8yG4UNaFGNu5/k/OjrVHsoQYlpA8cPQ4CFWBVf79aMynnL8OStnQdInyl9LpPve4DOHTsfVvvP4XEp+D4Di4/TGdGhnuIFLR/Mes1OyUUP0Y4MP5/3m0mRItHenCmKTz4nzX/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548240; c=relaxed/simple;
	bh=M9oSk3Zf7qsJwslg4Vg4AFxi07i+VDZr24aRI4ZkO+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBoWPQ0JDnEpUXjem9SRO85gTgIl9+RP1SMdCNxwDovivQ9dz4N2/tQI8s/+gAPR0/43CCsV5aoXewedulSkSrg+FCKpbld7i4A60KhXH8lUxrXnhRBL9qcXug12uHpWmoS0nTxQr90vI489MBcJYeIOtwNb92GWE9jW2EH14iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLrxf9yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLrxf9yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3123C433F1;
	Mon, 29 Jan 2024 17:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548239;
	bh=M9oSk3Zf7qsJwslg4Vg4AFxi07i+VDZr24aRI4ZkO+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLrxf9youg0AbaWtugLJygIG0cTpG8X4Amw3EzbEMEW29MEBU1WY9Wb5Q5v0N7pDp
	 z0wfD7lyuMalkqmHh5XFc9c8J2baFFFA5bT30WwNhBj50wLHRYxLzJdAh7azUcuMUV
	 C6LIumtZjFO1/eOvgUEOiiKYuqvrpiQvrM8jgKUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 266/346] drm/amd/pm: Add error log for smu v13.0.6 reset
Date: Mon, 29 Jan 2024 09:04:57 -0800
Message-ID: <20240129170024.214519669@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 91739a897c12dcec699e53f390be1b4abdeef3a0 upstream.

For all mode-2 reset fail cases, add error log.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -2192,17 +2192,18 @@ static int smu_v13_0_6_mode2_reset(struc
 			continue;
 		}
 
-		if (ret) {
-			dev_err(adev->dev,
-				"failed to send mode2 message \tparam: 0x%08x error code %d\n",
-				SMU_RESET_MODE_2, ret);
+		if (ret)
 			goto out;
-		}
+
 	} while (ret == -ETIME && timeout);
 
 out:
 	mutex_unlock(&smu->message_lock);
 
+	if (ret)
+		dev_err(adev->dev, "failed to send mode2 reset, error code %d",
+			ret);
+
 	return ret;
 }
 


