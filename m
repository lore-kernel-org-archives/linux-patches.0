Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265D619E7D0;
	Tue, 16 Jul 2024 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145239; cv=none; b=GRb0jqL9YrXU7iBmOUZmfudY00UUar7TRkOJGYvEwTcfJhp5T5ULotBV4DwMcbnhTvLxH0PjXeZmH1MECXwXraW+TfjD8j88NTAEdAfwy/e4OMoeiJ27YQQWAbwO+QIRO7ntcfkMCF+AzVmvyBbBLqamDx+bXf6Ft8N9ef22EKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145239; c=relaxed/simple;
	bh=JdyKmYJYzXkL/utsWyIuY/QV/x2cs6LhDc2EIQxpupo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4qkuKsB93mjZ4NG7fSmpFm9s3dQB1hUXGqu55JB0Jt0rYCK/KcusgfjJbxY0SccgbvDo+gJQeXo4PKUqTnM5aQiq8UNKBaHxAegNnVj7qhivO4DDAKlrm6zdlwcXIJJOrRGeaq3JMa+TiuzaFMMyJqNPFj1yj1mXzDFAddbdD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLcBu0Ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLcBu0Ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF29C116B1;
	Tue, 16 Jul 2024 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145239;
	bh=JdyKmYJYzXkL/utsWyIuY/QV/x2cs6LhDc2EIQxpupo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLcBu0RaOxzYdixof+UX9G35Jia4ercHQ3T8qlZyMSsfB8XzZpDL3YLlePnNsghqK
	 gfbgXpFkIMkDLMwmTfpbT86sWNQWntXlU9eR9OmsojLy0JYj6apZQu/aJimacGg0fn
	 w5e4IH/5PXbX+u2xGv528es9J/N1FNBbC2eolUxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.9 126/143] misc: fastrpc: Copy the complete capability structure to user
Date: Tue, 16 Jul 2024 17:32:02 +0200
Message-ID: <20240716152800.833556128@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit e7f0be3f09c6e955dc8009129862b562d8b64513 upstream.

User is passing capability ioctl structure(argp) to get DSP
capabilities. This argp is copied to a local structure to get domain
and attribute_id information. After getting the capability, only
capability value is getting copied to user argp which will not be
useful if the use is trying to get the capability by checking the
capability member of fastrpc_ioctl_capability structure. Copy the
complete capability structure so that user can get the capability
value from the expected member of the structure.

Fixes: 6c16fd8bdd40 ("misc: fastrpc: Add support to get DSP capabilities")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628114501.14310-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1787,7 +1787,7 @@ static int fastrpc_get_dsp_info(struct f
 	if (err)
 		return err;
 
-	if (copy_to_user(argp, &cap.capability, sizeof(cap.capability)))
+	if (copy_to_user(argp, &cap, sizeof(cap)))
 		return -EFAULT;
 
 	return 0;


