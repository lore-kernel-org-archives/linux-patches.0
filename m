Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2405B79D8;
	Sat, 30 Dec 2023 12:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYzpUUNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E90C433C7;
	Sat, 30 Dec 2023 12:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938062;
	bh=KFb2wCdXl+NHMUSyImIUk0cwDyryKhigftBtqdMaIGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYzpUUNll3fRzTAhG5+e0QJcJzMYItZkE04qGbrgv7yWBZEuktVr8R1I8DxytRgvR
	 WDyjhgkF6Pc4HMoXPF9PW2K1K5ZR73VL1HifnrexVHmWOz52PSyGjN900ONzkYnFZr
	 S+qA3hAwkG/UBPbCpD3Fe9phl9uWnz+aix+X8+iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/112] wifi: mac80211: mesh: check element parsing succeeded
Date: Sat, 30 Dec 2023 11:58:45 +0000
Message-ID: <20231230115807.145742478@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1fc4a3eec50d726f4663ad3c0bb0158354d6647a ]

ieee802_11_parse_elems() can return NULL, so we must
check for the return value.

Fixes: 5d24828d05f3 ("mac80211: always allocate struct ieee802_11_elems")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231211085121.93dea364f3d3.Ie87781c6c48979fb25a744b90af4a33dc2d83a28@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_plink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index bd0b7c189adfa..c54acdc8d00ab 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -1230,6 +1230,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			return;
 	}
 	elems = ieee802_11_parse_elems(baseaddr, len - baselen, true, NULL);
-	mesh_process_plink_frame(sdata, mgmt, elems, rx_status);
-	kfree(elems);
+	if (elems) {
+		mesh_process_plink_frame(sdata, mgmt, elems, rx_status);
+		kfree(elems);
+	}
 }
-- 
2.43.0



