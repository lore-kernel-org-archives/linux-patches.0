Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F243482C1;
	Mon,  1 Apr 2024 15:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986844; cv=none; b=iRL9I9tVE71+HKGOmU8Q872qd+PAP7+i/zonBhT/D28GwWXLGJgQhc9ZqiEoEN83HoYbL19uCTETvuyuXU/Q6Bqf9R8R1xUGJQAZF0uijnECV1wsDF6UIRecZ0rCXT9wQsFgRn8W6QTXn7GGVfhCTwp4Ga5CA1nfQMHGZ7cpB8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986844; c=relaxed/simple;
	bh=HhGvUUlrMHTP4L6Ibp3Q04P1c6VqYtuc9EIDxmhBvDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag7O+kKXMhpnDH/ietyicd31J1wi3za+uI44Cgb0+o99zAD9KnC+OZ3CCcPWNI5xiOaOG4XAi8cEnH2YNQjDZeQmNuTKZnKJjffKOFWHKl8zFyICUdj/bRwXRBdh76b/4tEIRiUH7KTgJywCS84Uz90NAqlbnVCqmtUSSj7RhlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLiu57Ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLiu57Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE30BC433C7;
	Mon,  1 Apr 2024 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986844;
	bh=HhGvUUlrMHTP4L6Ibp3Q04P1c6VqYtuc9EIDxmhBvDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLiu57Igadh123IsZMYhqzzjYAbMMsuGIksSdFqSiSgclsGkthMu5KXmjV5pALfJx
	 QVQ3Udy7vqy8fYef/rfbILMED27dx35H0dmdRM+BorwImjdmV93z7JyndjnGzH2o2X
	 vCKCNqaT39YhvcCK/xnsZUqsbOy5vYcLICbT2l1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 073/399] clk: qcom: gcc-ipq9574: fix terminating of frequency table arrays
Date: Mon,  1 Apr 2024 17:40:39 +0200
Message-ID: <20240401152551.363032256@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit bd2b6395671d823caa38d8e4d752de2448ae61e1 ]

The frequency table arrays are supposed to be terminated with an
empty element. Add such entry to the end of the arrays where it
is missing in order to avoid possible out-of-bound access when
the table is traversed by functions like qcom_find_freq() or
qcom_find_freq_floor().

Only compile tested.

Fixes: d75b82cff488 ("clk: qcom: Add Global Clock Controller driver for IPQ9574")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240229-freq-table-terminator-v1-4-074334f0905c@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq9574.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq9574.c b/drivers/clk/qcom/gcc-ipq9574.c
index e8190108e1aef..0a3f846695b80 100644
--- a/drivers/clk/qcom/gcc-ipq9574.c
+++ b/drivers/clk/qcom/gcc-ipq9574.c
@@ -2082,6 +2082,7 @@ static struct clk_branch gcc_sdcc1_apps_clk = {
 static const struct freq_tbl ftbl_sdcc_ice_core_clk_src[] = {
 	F(150000000, P_GPLL4, 8, 0, 0),
 	F(300000000, P_GPLL4, 4, 0, 0),
+	{ }
 };
 
 static struct clk_rcg2 sdcc1_ice_core_clk_src = {
-- 
2.43.0



