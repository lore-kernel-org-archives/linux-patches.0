Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B8855E5E;
	Sat,  3 Feb 2024 04:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933976; cv=none; b=vFu7zLnjMNRKQIphabKjVt5ea7xZvQK7b5GQFnLubYyJtwm4dIwmYsedbdSEFioiGeRsYbPWAMCoG4w3/6IFnj3gIiE7oDGNaZJ6ni40LaMa177ZM0yzwOYBruX1NpVkDsoUWgaMdJUZpe3GK2Di1xh7RSbRaR8lWg1KuXtiPgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933976; c=relaxed/simple;
	bh=n4Wd4U3K86mYrnwn8GtE/hjQ5oWHmF0QxHIUEexTRVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPKS/N9C8zs3voPyx0qyXYONCY6kd9N/YEA5TF1gKLkF7T8MGaq8X0JVtfyTsH0QUBdEt1MtXWdRjDUFNZmpyvU7tFPEnzl+vhmkl0JghA1Ef48+tYJjktvzwDhk8VzJNS+z+cPHbbOqrFmQD3XwGZmNmlv7xwFFFMHgl0ks2QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnafXMXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnafXMXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A629C433C7;
	Sat,  3 Feb 2024 04:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933976;
	bh=n4Wd4U3K86mYrnwn8GtE/hjQ5oWHmF0QxHIUEexTRVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnafXMXNhcJ4j/1F8cjXnwRCZA3AlZmjBnJANkLljYwRixYLj52c7hNRTEldzgMjc
	 IKjii86igbVtR3JziV2mEO+ZB5/7uYE71wCNXo0hQMSwnsATQZmyh4YsW3Cz8NBb0t
	 z16bNRCF6JYLVghJSLDlowFjtnQSU4evCjnantaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.7 350/353] Revert "drm/amd/display: Disable PSR-SU on Parade 0803 TCON again"
Date: Fri,  2 Feb 2024 20:07:48 -0800
Message-ID: <20240203035414.816819631@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Jonathan Gray <jsg@jsg.id.au>

This reverts commit f015d8b6405d950f30826b4d8d9e1084dd9ea2a4.

duplicated a change made in 6.7
e7ab758741672acb21c5d841a9f0309d30e48a06

Cc: stable@vger.kernel.org # 6.7
Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/power/power_helpers.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
@@ -841,8 +841,6 @@ bool is_psr_su_specific_panel(struct dc_
 				isPSRSUSupported = false;
 			else if (dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x03)
 				isPSRSUSupported = false;
-			else if (dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x03)
-				isPSRSUSupported = false;
 			else if (dpcd_caps->psr_info.force_psrsu_cap == 0x1)
 				isPSRSUSupported = true;
 		}


